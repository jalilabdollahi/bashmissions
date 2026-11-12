#!/usr/bin/env bash
set -euo pipefail

if (( $# == 0 )); then
  echo "usage: solution.sh NAME..." >&2
  exit 2
fi

problems=0

for name in "$@"; do
  file_var="${name}_FILE"
  # ${!name} = the value of the variable whose NAME is stored in $name.
  # ":-" keeps set -u quiet when the variable does not exist at all.
  direct=${!name:-}
  path=${!file_var:-}

  if [[ -n $direct && -n $path ]]; then
    echo "$name: set $name or $file_var, not both" >&2
    problems=$(( problems + 1 ))
    continue
  fi

  if [[ -n $path ]]; then
    if [[ ! -f $path || ! -r $path ]]; then
      echo "$name: cannot read $path" >&2
      problems=$(( problems + 1 ))
      continue
    fi
    secret=$(<"$path")          # reads the file; trailing newlines are dropped
    source_name=file
  elif [[ -n $direct ]]; then
    secret=$direct
    source_name=env
  else
    echo "$name: missing" >&2
    problems=$(( problems + 1 ))
    continue
  fi

  if [[ -z $secret ]]; then
    echo "$name: secret file is empty" >&2
    problems=$(( problems + 1 ))
    continue
  fi

  # Report the length only: the secret itself never reaches the output.
  echo "$name: ${#secret} chars from $source_name"
done

(( problems == 0 )) || exit 1
