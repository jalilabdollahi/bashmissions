#!/usr/bin/env bash
# Config manager: layered settings with types, sources, masked secrets and exports.
set -euo pipefail

usage() {
  echo "usage: solution.sh [--layer FILE]... [--set KEY=VALUE]... [--prefix P] [--reveal] SCHEMA COMMAND [ARG]" >&2
  exit 2
}

layers=() sets=()
prefix=APP
reveal=0
while (( $# > 0 )); do
  case $1 in
    --layer) [[ -n ${2:-} ]] || usage; layers+=("$2"); shift 2 ;;
    --set) [[ $# -ge 2 ]] || usage; sets+=("$2"); shift 2 ;;
    --prefix) [[ -n ${2:-} ]] || usage; prefix=$2; shift 2 ;;
    --reveal) reveal=1; shift ;;
    -*) usage ;;
    *) break ;;
  esac
done
(( $# >= 2 )) || usage
schema=$1 command=$2
shift 2
case $command in
  validate | show) (( $# == 0 )) || usage ;;
  get) (( $# == 1 )) || usage ;;
  export)
    (( $# == 1 )) || usage
    case $1 in env | json | shell) ;; *) usage ;; esac
    ;;
  *) usage ;;
esac
for f in "$schema" "${layers[@]:-}"; do
  [[ -z $f ]] && continue
  if [[ ! -r $f ]]; then
    echo "error: cannot read $f" >&2
    exit 2
  fi
done

trim() { local s=$1; s=${s#"${s%%[![:space:]]*}"}; s=${s%"${s##*[![:space:]]}"}; printf '%s' "$s"; }
unquote() {
  local s=$1
  if [[ ${#s} -ge 2 && ( ( $s == \"*\" ) || ( $s == \'*\' ) ) ]]; then s=${s:1:${#s}-2}; fi
  printf '%s' "$s"
}

# ---- schema ----------------------------------------------------------------------
keys=()
declare -A type_of default_of flags_of value source
while IFS='|' read -r key type def flags _; do
  key=$(trim "$key")
  [[ -z $key || $key == \#* ]] && continue
  keys+=("$key")
  type_of[$key]=$type default_of[$key]=$def flags_of[$key]=$flags
  value[$key]=$def source[$key]=default
done < "$schema"

errors=()

# ---- layers ------------------------------------------------------------------------
for f in "${layers[@]:-}"; do
  [[ -n $f ]] || continue
  lineno=0
  while IFS= read -r line || [[ -n $line ]]; do
    lineno=$((lineno + 1))
    t=$(trim "$line")
    [[ -z $t || $t == \#* ]] && continue
    if [[ $t != *=* ]]; then
      errors+=("bad line in $f:$lineno: expected key = value")
      continue
    fi
    k=$(trim "${t%%=*}")
    v=$(unquote "$(trim "${t#*=}")")
    if [[ -z ${type_of[$k]+set} ]]; then
      errors+=("unknown key '$k' in $f:$lineno")
      continue
    fi
    value[$k]=$v source[$k]=${f##*/}
  done < "$f"
done

# environment: PREFIX_DB_PORT for db.port
for k in "${keys[@]}"; do
  envname=${k//./_}
  envname=${envname//-/_}
  envname=${prefix}_${envname^^}
  if [[ -v $envname ]]; then
    value[$k]=${!envname} source[$k]=env
  fi
done

# --set
for kv in "${sets[@]:-}"; do
  [[ -n $kv ]] || continue
  if [[ $kv != *=* ]]; then
    errors+=("bad --set '$kv': expected KEY=VALUE")
    continue
  fi
  k=${kv%%=*}
  if [[ -z ${type_of[$k]+set} ]]; then
    errors+=("unknown key '$k' in --set")
    continue
  fi
  value[$k]=${kv#*=} source[$k]=--set
done

# ---- validation, in schema order --------------------------------------------------------
for k in "${keys[@]}"; do
  v=${value[$k]}
  if [[ -z $v ]]; then
    [[ ${flags_of[$k]} != *required* ]] || errors+=("$k: required but not set")
    continue
  fi
  case ${type_of[$k]} in
    int)
      [[ $v =~ ^-?[0-9]+$ ]] || errors+=("$k: '$v' is not an integer")
      ;;
    port)
      if [[ ! $v =~ ^[0-9]+$ ]] || (( 10#$v < 1 || 10#$v > 65535 )); then
        errors+=("$k: '$v' is not a valid port (1-65535)")
      fi
      ;;
    bool)
      case ${v,,} in
        true | yes | on | 1) value[$k]=true ;;
        false | no | off | 0) value[$k]=false ;;
        *) errors+=("$k: '$v' is not a boolean") ;;
      esac
      ;;
    enum:*)
      allowed=${type_of[$k]#enum:}
      if [[ ",$allowed," != *",$v,"* ]]; then
        errors+=("$k: '$v' is not one of ${allowed//,/, }")
      fi
      ;;
  esac
done

if (( ${#errors[@]} > 0 )); then
  for e in "${errors[@]}"; do echo "config error: $e" >&2; done
  exit 1
fi

# ---- commands ------------------------------------------------------------------------------
is_secret() { [[ ${flags_of[$1]} == *secret* ]]; }
shown() {  # KEY -> value as shown to a human
  if is_secret "$1" && [[ -n ${value[$1]} ]] && (( ! reveal )); then printf '********'; else printf '%s' "${value[$1]}"; fi
}

case $command in
  validate)
    echo "config ok (${#keys[@]} keys)"
    ;;
  show)
    printf '%-14s %-20s %s\n' KEY VALUE SOURCE
    for k in "${keys[@]}"; do
      printf '%-14s %-20s %s\n' "$k" "$(shown "$k")" "${source[$k]}"
    done
    ;;
  get)
    k=$1
    if [[ -z ${type_of[$k]+set} ]]; then
      echo "error: unknown key '$k'" >&2
      exit 2
    fi
    shown "$k"
    echo
    ;;
  export)
    format=$1
    exported=()
    for k in "${keys[@]}"; do
      if is_secret "$k" && (( ! reveal )); then continue; fi
      exported+=("$k")
    done
    envname() { local n=${1//./_}; n=${n//-/_}; printf '%s_%s' "$prefix" "${n^^}"; }
    case $format in
      env)
        for k in "${exported[@]:-}"; do
          [[ -z $k ]] || printf '%s=%s\n' "$(envname "$k")" "${value[$k]}"
        done
        ;;
      shell)
        for k in "${exported[@]:-}"; do
          [[ -n $k ]] || continue
          v=${value[$k]//\'/\'\\\'\'}
          printf "export %s='%s'\n" "$(envname "$k")" "$v"
        done
        ;;
      json)
        echo "{"
        n=${#exported[@]} i=0
        for k in "${exported[@]:-}"; do
          [[ -n $k ]] || continue
          i=$((i + 1))
          v=${value[$k]}
          case ${type_of[$k]} in
            int | port | bool) [[ -n $v ]] && j=$v || j='""' ;;
            *)
              v=${v//\\/\\\\}
              v=${v//\"/\\\"}
              j="\"$v\""
              ;;
          esac
          sep=,
          (( i < n )) || sep=
          printf '  "%s": %s%s\n' "$k" "$j" "$sep"
        done
        echo "}"
        ;;
    esac
    ;;
esac
