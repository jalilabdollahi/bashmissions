#!/usr/bin/env bash
set -euo pipefail

declare -A flag file default
default=([retention]=7 [dest]=/var/backups [compress]=no)
config=

# --- layer: flags -----------------------------------------------------------
while (( $# )); do
  case $1 in
    --retention|--dest|--config)
      if (( $# < 2 )); then
        echo "missing value for $1" >&2
        exit 2
      fi
      name=${1#--}
      flag[$name]=$2
      shift 2
      ;;
    --retention=*|--dest=*|--config=*)
      name=${1#--}
      name=${name%%=*}
      flag[$name]=${1#*=}
      shift
      ;;
    --compress)
      flag[compress]=yes
      shift
      ;;
    -*)
      echo "unknown option: $1" >&2
      exit 2
      ;;
    *)
      echo "unexpected argument: $1" >&2
      exit 2
      ;;
  esac
done
config=${flag[config]:-}

# --- layer: file ------------------------------------------------------------
if [[ -n $config ]]; then
  if [[ ! -r $config ]]; then
    echo "cannot read $config" >&2
    exit 1
  fi
  while IFS='=' read -r key value || [[ -n $key ]]; do
    key=${key#"${key%%[![:space:]]*}"};     key=${key%"${key##*[![:space:]]}"}
    value=${value:-}
    value=${value#"${value%%[![:space:]]*}"}; value=${value%"${value##*[![:space:]]}"}
    if [[ $key == @(retention|dest|compress) && -n $value ]]; then
      file[$key]=$value
    fi
  done < "$config"
fi

# --- decide: strongest layer first -------------------------------------------
for name in retention dest compress; do
  envvar=TIDE_${name^^}
  if [[ -n ${flag[$name]:-} ]]; then
    value=${flag[$name]} source=flag
  elif [[ -n ${!envvar:-} ]]; then          # ${!envvar} = value of the variable named by $envvar
    value=${!envvar} source=env
  elif [[ -n ${file[$name]:-} ]]; then
    value=${file[$name]} source=file
  else
    value=${default[$name]} source=default
  fi
  echo "$name: $value ($source)"
done
