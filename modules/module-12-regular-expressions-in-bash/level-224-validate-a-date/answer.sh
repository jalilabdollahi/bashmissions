#!/usr/bin/env bash
set -euo pipefail

re='^([0-9]{4})-([0-9]{2})-([0-9]{2})$'

while IFS= read -r entry || [[ -n $entry ]]; do
  if ! [[ $entry =~ $re ]]; then
    echo "$entry: bad format"
    continue
  fi

  # Copy the groups first, with 10# so 08 and 09 are decimal, not broken octal.
  year=$(( 10#${BASH_REMATCH[1]} ))
  month=$(( 10#${BASH_REMATCH[2]} ))
  day=$(( 10#${BASH_REMATCH[3]} ))

  if (( month < 1 || month > 12 )); then
    echo "$entry: bad month"
    continue
  fi

  case $month in
    4|6|9|11) max=30 ;;
    2)
      if (( year % 400 == 0 || (year % 4 == 0 && year % 100 != 0) )); then
        max=29
      else
        max=28
      fi
      ;;
    *) max=31 ;;
  esac

  if (( day < 1 || day > max )); then
    echo "$entry: bad day"
  else
    echo "$entry: ok"
  fi
done
