#!/usr/bin/env bash
# Observability kit: counters, structured logs and spans in one folder, with a
# report that joins them. Trace and parent ids travel in the environment.
set -euo pipefail

usage() {
  echo "usage: solution.sh OUT metric inc NAME [N] | metric set NAME VALUE | log LEVEL MESSAGE... | span NAME -- COMMAND... | report [--slow N]" >&2
  exit 2
}

[[ $# -ge 2 ]] || usage
out=$1 mode=$2
shift 2
[[ -d $out ]] || { echo "no such directory: $out" >&2; exit 2; }

metrics=$out/metrics.txt logs=$out/logs.txt spans=$out/spans.txt ids=$out/ids
is_uint() { [[ $1 =~ ^[0-9]+$ ]]; }
name_re='^[a-z][a-z0-9_.]*$'
tmp=
cleanup() { [[ -n $tmp ]] && rm -f "$tmp"; return 0; }
trap cleanup EXIT

# replace_file TARGET: stdin becomes the new content, atomically.
replace_file() {
  tmp=$(mktemp "$1.XXXXXX")
  cat > "$tmp"
  mv -f "$tmp" "$1"
  tmp=
}

# metric_apply inc|set NAME VALUE -> prints the new value
declare -A mval
metric_apply() {
  local op=$1 name=$2 val=$3 k v
  mval=()
  if [[ -r $metrics ]]; then
    while read -r k v; do
      [[ -n $k ]] && mval[$k]=$v
    done < "$metrics"
  fi
  if [[ $op == inc ]]; then
    mval[$name]=$(( ${mval[$name]:-0} + val ))
  else
    mval[$name]=$val
  fi
  for k in "${!mval[@]}"; do echo "$k ${mval[$k]}"; done | LC_ALL=C sort | replace_file "$metrics"
  echo "${mval[$name]}"
}

# alloc KIND -> next number of that counter (trace or span), persisted in ids
alloc() {
  local kind=$1 t=0 s=0 line
  if [[ -r $ids ]]; then
    read -r line < "$ids"
    [[ $line =~ ^trace=([0-9]+)\ span=([0-9]+)$ ]] && { t=${BASH_REMATCH[1]}; s=${BASH_REMATCH[2]}; }
  fi
  if [[ $kind == trace ]]; then t=$((t + 1)); echo "$t"; else s=$((s + 1)); echo "$s"; fi > "$out/.alloc.value"
  printf 'trace=%s span=%s\n' "$t" "$s" | replace_file "$ids"
  allocated=$(< "$out/.alloc.value")
  rm -f "$out/.alloc.value"
}

case $mode in
  metric)
    [[ $# -ge 2 ]] || usage
    op=$1 name=$2
    shift 2
    [[ $name =~ $name_re ]] || usage
    case $op in
      inc) n=${1:-1}; [[ $# -le 1 ]] || usage ;;
      set) [[ $# -eq 1 ]] || usage; n=$1 ;;
      *) usage ;;
    esac
    is_uint "$n" || usage
    v=$(metric_apply "$op" "$name" "$n")
    echo "$name=$v"
    ;;
  log)
    [[ $# -ge 2 ]] || usage
    level=${1,,}
    shift
    case $level in debug|info|warn|error) ;; *) usage ;; esac
    now=$(date +%s)
    echo "$now $level trace=${OBS_TRACE:--} $*" >> "$logs"
    metric_apply inc "log.$level" 1 > /dev/null
    ;;
  span)
    [[ $# -ge 3 ]] || usage
    sname=$1
    [[ $sname =~ ^[a-z0-9._-]+$ && $2 == -- ]] || usage
    shift 2
    if [[ -n ${OBS_TRACE:-} ]]; then
      trace=$OBS_TRACE
    else
      alloc trace
      trace=t$allocated
    fi
    alloc span
    sid=s$allocated
    parent=${OBS_PARENT:--}
    start=$(date +%s)
    status=0
    OBS_TRACE=$trace OBS_PARENT=$sid "$@" || status=$?
    end=$(date +%s)
    if (( status == 0 )); then label=ok; else label=exit=$status; fi
    echo "$trace $sid $parent $start $((end - start)) $label $sname" >> "$spans"
    metric_apply inc span.total 1 > /dev/null
    (( status == 0 )) || metric_apply inc span.errors 1 > /dev/null
    exit "$status"
    ;;
  report)
    slow=5
    if [[ ${1:-} == --slow ]]; then
      [[ $# -eq 2 ]] && is_uint "$2" || usage
      slow=$2
    else
      [[ $# -eq 0 ]] || usage
    fi
    echo "== metrics =="
    if [[ -s $metrics ]]; then cat "$metrics"; else echo "(none)"; fi

    echo "== logs =="
    declare -A lc=([debug]=0 [info]=0 [warn]=0 [error]=0)
    errlines=()
    if [[ -r $logs ]]; then
      while read -r ts level tr msg; do
        [[ -n $level ]] || continue
        lc[$level]=$(( ${lc[$level]:-0} + 1 ))
        [[ $level == error ]] && errlines+=("error $tr: $msg")
      done < "$logs"
    fi
    echo "levels: debug=${lc[debug]} info=${lc[info]} warn=${lc[warn]} error=${lc[error]}"
    for l in "${errlines[@]:-}"; do [[ -n $l ]] && echo "$l"; done

    echo "== traces =="
    declare -A sname_of sdur sstat sparent strace kids
    traces=()
    nspans=0 nerr=0 nslow=0
    if [[ -r $spans ]]; then
      while read -r tr sid parent start dur stat nm; do
        [[ -n $sid ]] || continue
        sname_of[$sid]=$nm sdur[$sid]=$dur sstat[$sid]=$stat sparent[$sid]=$parent strace[$sid]=$tr
        nspans=$((nspans + 1))
        [[ $stat == ok ]] || nerr=$((nerr + 1))
        case " ${traces[*]:-} " in *" $tr "*) ;; *) traces+=("$tr") ;; esac
      done < "$spans"
    fi
    if (( nspans == 0 )); then
      echo "(none)"
    else
      # children per parent, and the roots of each trace
      for sid in "${!sname_of[@]}"; do
        p=${sparent[$sid]}
        if [[ $p != - && -n ${sname_of[$p]:-} ]]; then
          kids[$p]+="$sid "
        else
          kids["root:${strace[$sid]}"]+="$sid "
        fi
      done
      by_number() { tr ' ' '\n' | sed '/^$/d' | sort -t s -k2,2n; }
      show() {   # SPAN DEPTH
        local sid=$1 depth=$2 line pad k
        printf -v pad '%*s' $(( (depth + 1) * 2 )) ''
        line="$pad$sid ${sname_of[$sid]} ${sdur[$sid]}s ${sstat[$sid]}"
        if (( sdur[$sid] > slow )); then line+=" SLOW"; nslow=$((nslow + 1)); fi
        echo "$line"
        for k in $(echo "${kids[$sid]:-}" | by_number); do show "$k" $((depth + 1)); done
      }
      for tr in $(printf '%s\n' "${traces[@]}" | sort -t t -k2,2n); do
        echo "trace $tr"
        for r in $(echo "${kids["root:$tr"]:-}" | by_number); do show "$r" 0; done
      done
    fi
    echo "summary: traces=${#traces[@]} spans=$nspans errors=$nerr slow=$nslow"
    ;;
  *) usage ;;
esac
