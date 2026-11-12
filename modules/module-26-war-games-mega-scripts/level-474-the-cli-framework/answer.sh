#!/usr/bin/env bash
# lantern: a crew-roster CLI built on a small command registry.
# Commands and options are data; the parser, the help screens and the hints are generated.
set -euo pipefail

prog=lantern
version="lantern 1.4.0"

# ---- the registry ---------------------------------------------------------------
cmds=(add list remove show help version)
declare -A desc argword minargs maxargs opts allowed
desc[add]="Add a crew member"
desc[list]="List crew members"
desc[remove]="Remove a crew member"
desc[show]="Show one crew member"
desc[help]="Show help for a command"
desc[version]="Print the version"
argword[add]=NAME;       minargs[add]=1;     maxargs[add]=1
argword[list]=;          minargs[list]=0;    maxargs[list]=0
argword[remove]=NAME;    minargs[remove]=1;  maxargs[remove]=1
argword[show]=NAME;      minargs[show]=1;    maxargs[show]=1
argword[help]="[COMMAND]"; minargs[help]=0;  maxargs[help]=1
argword[version]=;       minargs[version]=0; maxargs[version]=0
# one option per line: SHORT|LONG|VALUENAME|TEXT   (empty VALUENAME = a flag)
opts[add]='r|role|ROLE|Role: pilot, engineer or cook (default: engineer)
s|shift|SHIFT|Shift: day or night (default: day)'
opts[list]='r|role|ROLE|Only this role
f|format|FORMAT|table or csv (default: table)'
opts[remove]='f|force||Remove without asking'
allowed[role]="pilot engineer cook"
allowed[shift]="day night"
allowed[format]="table csv"

cmd=

# ---- generated help --------------------------------------------------------------
overall_help() {
  local c
  echo "$version - crew roster for the storm shift"
  echo
  echo "Usage: $prog [--db FILE] COMMAND [OPTIONS] [ARGS]"
  echo
  echo "Commands:"
  for c in "${cmds[@]}"; do
    printf '  %-8s %s\n' "$c" "${desc[$c]}"
  done
  echo
  echo "Run '$prog help COMMAND' for details."
}

command_help() {
  local c=$1 short long val text label usage="Usage: $prog $1"
  [[ -z ${opts[$c]:-} ]] || usage+=" [OPTIONS]"
  [[ -z ${argword[$c]} ]] || usage+=" ${argword[$c]}"
  echo "$usage"
  echo
  echo "${desc[$c]}"
  if [[ -n ${opts[$c]:-} ]]; then
    echo
    echo "Options:"
    while IFS='|' read -r short long val text; do
      label="-$short, --$long"
      [[ -z $val ]] || label+=" $val"
      printf '  %-20s %s\n' "$label" "$text"
    done <<< "${opts[$c]}"
  fi
}

# ---- errors and hints ----------------------------------------------------------------
usage_error() {
  if [[ -n $cmd ]]; then
    echo "$prog $cmd: $1" >&2
    echo "Run '$prog help $cmd' for usage." >&2
  else
    echo "$prog: $1" >&2
    echo "Run '$prog help' for usage." >&2
  fi
  exit 64
}

# subseq NEEDLE HAYSTACK: are the letters of NEEDLE found in order inside HAYSTACK?
subseq() {
  local needle=$1 hay=$2 i=0 j
  for (( j = 0; j < ${#hay} && i < ${#needle}; j++ )); do
    if [[ ${hay:j:1} == "${needle:i:1}" ]]; then i=$((i + 1)); fi
  done
  (( i == ${#needle} ))
}

# suggest PREFIX TYPED CANDIDATE...: prints " (did you mean 'PREFIXcandidate'?)" or nothing.
suggest() {
  local prefix=$1 typed=${2#-} cand
  typed=${typed#-}
  shift 2
  (( ${#typed} >= 2 )) || return 0
  for cand in "$@"; do
    if [[ $cand != "$typed" ]] && subseq "$typed" "$cand"; then
      printf " (did you mean '%s%s'?)" "$prefix" "$cand"
      return 0
    fi
  done
}

join_or() {
  local -a v=($1)
  local out="" i
  for i in "${!v[@]}"; do
    if (( i == 0 )); then out=${v[i]}
    elif (( i == ${#v[@]} - 1 )); then out+=" or ${v[i]}"
    else out+=", ${v[i]}"
    fi
  done
  printf '%s' "$out"
}

# ---- generic option parser ----------------------------------------------------------------
declare -A opt
pos=()
o_long= o_val=

find_opt() {  # NAME KIND(long|short): sets o_long / o_val
  local short long val text
  while IFS='|' read -r short long val text; do
    if { [[ $2 == long && $long == "$1" ]] || [[ $2 == short && $short == "$1" ]]; }; then
      o_long=$long
      o_val=$val
      return 0
    fi
  done <<< "${opts[$cmd]:-}"
  return 1
}

parse_args() {
  local arg name kind typed inline has_inline v short long longs=()
  while IFS='|' read -r short long _ _; do
    [[ -z $long ]] || longs+=("$long")
  done <<< "${opts[$cmd]:-}"
  while (( $# > 0 )); do
    arg=$1
    case $arg in
      --) shift; pos+=("$@"); return 0 ;;
      --help | -h) command_help "$cmd"; exit 0 ;;
      -?*)
        if [[ $arg == --* ]]; then name=${arg#--} kind=long; else name=${arg#-} kind=short; fi
        inline= has_inline=0
        if [[ $kind == long && $name == *=* ]]; then
          inline=${name#*=} name=${name%%=*} has_inline=1
        fi
        typed=${arg%%=*}
        if ! find_opt "$name" "$kind"; then
          usage_error "unknown option '$typed'$(suggest -- "$name" "${longs[@]:-}")"
        fi
        if [[ -z $o_val ]]; then
          opt[$o_long]=1
        else
          if (( has_inline )); then
            v=$inline
          else
            (( $# >= 2 )) || usage_error "option '$typed' needs a value"
            v=$2
            shift
          fi
          if [[ -n ${allowed[$o_long]:-} && " ${allowed[$o_long]} " != *" $v "* ]]; then
            usage_error "invalid value '$v' for --$o_long (expected $(join_or "${allowed[$o_long]}"))"
          fi
          opt[$o_long]=$v
        fi
        ;;
      *) pos+=("$arg") ;;
    esac
    shift
  done
}

# ---- global options and dispatch ---------------------------------------------------------------
db=${LANTERN_DB:-crew.db}
while (( $# > 0 )); do
  case $1 in
    -h | --help) overall_help; exit 0 ;;
    -V | --version) echo "$version"; exit 0 ;;
    --db)
      (( $# >= 2 )) || usage_error "option '--db' needs a value"
      db=$2
      shift 2
      ;;
    --db=*) db=${1#*=}; shift ;;
    --) shift; break ;;
    -*) usage_error "unknown option '$1'$(suggest -- "$1" db help version)" ;;
    *) break ;;
  esac
done
if (( $# == 0 )); then
  overall_help >&2
  exit 64
fi
name=$1
shift
if [[ -z ${desc[$name]:-} ]]; then
  usage_error "unknown command '$name'$(suggest '' "$name" "${cmds[@]}")"
fi
cmd=$name

parse_args "$@"
if (( ${#pos[@]} < minargs[$cmd] )); then
  usage_error "missing ${argword[$cmd]}"
fi
if (( ${#pos[@]} > maxargs[$cmd] )); then
  usage_error "unexpected argument '${pos[${maxargs[$cmd]}]}'"
fi

# ---- command handlers ---------------------------------------------------------------------------
fail() { echo "$prog: $1" >&2; exit 1; }

member_line() {  # NAME -> the stored line, case-insensitive match
  [[ -f $db ]] || return 0
  awk -F'|' -v n="$1" 'tolower($1) == tolower(n) { print; exit }' "$db"
}

cmd_add() {
  local n=${pos[0]} role=${opt[role]:-engineer} shift_=${opt[shift]:-day}
  [[ $n =~ ^[A-Za-z][A-Za-z-]*$ ]] || fail "'$n' is not a valid name"
  [[ -z $(member_line "$n") ]] || fail "'$n' is already on the roster"
  printf '%s|%s|%s\n' "$n" "$role" "$shift_" >> "$db"
  echo "added $n ($role, $shift_)"
}

cmd_list() {
  local role=${opt[role]:-} format=${opt[format]:-table} rows=
  if [[ -f $db ]]; then
    rows=$(awk -F'|' -v r="$role" 'r == "" || $2 == r' "$db" | sort -t'|' -k1,1)
  fi
  if [[ $format == csv ]]; then
    echo "name,role,shift"
    [[ -z $rows ]] || printf '%s\n' "$rows" | tr '|' ','
  elif [[ -z $rows ]]; then
    echo "(no crew)"
  else
    printf '%-12s %-10s %s\n' NAME ROLE SHIFT
    printf '%s\n' "$rows" | awk -F'|' '{ printf "%-12s %-10s %s\n", $1, $2, $3 }'
  fi
}

cmd_remove() {
  local n=${pos[0]} line stored
  [[ -n ${opt[force]:-} ]] || fail "refusing to remove '$n' without --force"
  line=$(member_line "$n")
  [[ -n $line ]] || fail "no such crew member '$n'"
  stored=${line%%|*}
  awk -F'|' -v n="$n" 'tolower($1) != tolower(n)' "$db" > "$db.new"
  mv "$db.new" "$db"
  echo "removed $stored"
}

cmd_show() {
  local n=${pos[0]} line name role shift_
  line=$(member_line "$n")
  [[ -n $line ]] || fail "no such crew member '$n'"
  IFS='|' read -r name role shift_ <<< "$line"
  echo "Name:  $name"
  echo "Role:  $role"
  echo "Shift: $shift_"
}

cmd_help() {
  if (( ${#pos[@]} == 0 )); then
    overall_help
  else
    if [[ -z ${desc[${pos[0]}]:-} ]]; then
      cmd=
      usage_error "unknown command '${pos[0]}'$(suggest '' "${pos[0]}" "${cmds[@]}")"
    fi
    command_help "${pos[0]}"
  fi
}

cmd_version() { echo "$version"; }

"cmd_$cmd"
