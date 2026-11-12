#!/usr/bin/env bash
set -euo pipefail

host=""
port=443
quiet="no"

# The leading colon in ":h:p:q" is "silent mode": getopts stops printing its own
# errors and instead reports problems to us through the variable opt:
#   opt='?'  unknown option letter, which is stored in $OPTARG
#   opt=':'  an option that needs a value had none, its letter is in $OPTARG
while getopts ":h:p:q" opt; do
  case $opt in
    h) host=$OPTARG ;;
    p) port=$OPTARG ;;
    q) quiet="yes" ;;
    \?) echo "error: unknown option: -$OPTARG" >&2; exit 2 ;;
    :)  echo "error: option -$OPTARG needs a value" >&2; exit 2 ;;
  esac
done

[[ -z $host ]] && { echo "usage: solution.sh -h HOST [-p PORT] [-q]" >&2; exit 2; }

if [[ $quiet == "yes" ]]; then
  echo "$host:$port"
else
  echo "probing $host on port $port"
fi
