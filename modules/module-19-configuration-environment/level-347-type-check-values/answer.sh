#!/usr/bin/env bash
set -euo pipefail

file=${1:-}
if [[ ! -r $file ]]; then
  echo "cannot read $file" >&2
  exit 2
fi

# Raw text first, defaults for names that never appear.
workers=2 debug=false log_level=info
while IFS='=' read -r key value || [[ -n $key ]]; do
  key=${key#"${key%%[![:space:]]*}"};       key=${key%"${key##*[![:space:]]}"}
  value=${value:-}
  value=${value#"${value%%[![:space:]]*}"}; value=${value%"${value##*[![:space:]]}"}
  case $key in
    workers)   workers=$value ;;
    debug)     debug=$value ;;
    log_level) log_level=$value ;;
  esac
done < "$file"

errors=0

# workers: digits only; 10# stops "08" being read as a broken octal number.
if [[ $workers =~ ^[0-9]+$ ]] && (( ${#workers} <= 18 )) && (( 10#$workers >= 1 && 10#$workers <= 64 )); then
  workers=$(( 10#$workers ))
else
  echo "invalid workers: \"$workers\" (expected an integer from 1 to 64)" >&2
  errors=$(( errors + 1 ))
fi

# debug: lowercase it, then map the accepted words onto two canonical values.
# We assign only on success, so the error message can still quote the original.
case ${debug,,} in
  true|yes|on|1)  debug=true ;;
  false|no|off|0) debug=false ;;
  *)
    echo "invalid debug: \"$debug\" (expected true/false, yes/no, on/off or 1/0)" >&2
    errors=$(( errors + 1 ))
    ;;
esac

# log_level: an enumeration is a short list of allowed words.
case ${log_level,,} in
  debug|info|warn|error) log_level=${log_level,,} ;;
  *)
    echo "invalid log_level: \"$log_level\" (expected debug, info, warn or error)" >&2
    errors=$(( errors + 1 ))
    ;;
esac

if (( errors > 0 )); then
  exit 1
fi
echo "workers=$workers"
echo "debug=$debug"
echo "log_level=$log_level"
