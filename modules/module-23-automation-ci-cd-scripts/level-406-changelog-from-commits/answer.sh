#!/usr/bin/env bash
set -euo pipefail

if (( $# != 1 )); then
  echo "usage: solution.sh VERSION" >&2
  exit 2
fi
version=$1

breaking=() features=() fixes=() other=()

# type, optional (scope), optional !, colon, space, text
re='^([a-z]+)(\(([^)]+)\))?(!)?: (.+)$'

while IFS= read -r subject || [[ -n $subject ]]; do
  [[ -z $subject || $subject == "Merge "* ]] && continue

  if [[ $subject =~ $re ]]; then
    type=${BASH_REMATCH[1]}
    scope=${BASH_REMATCH[3]}
    bang=${BASH_REMATCH[4]}
    text=${BASH_REMATCH[5]}

    bullet="- $text"
    [[ -n $scope ]] && bullet="- $scope: $text"

    if [[ -n $bang ]]; then
      breaking+=("$bullet")
    elif [[ $type == feat ]]; then
      features+=("$bullet")
    elif [[ $type == fix ]]; then
      fixes+=("$bullet")
    else
      other+=("- $subject")         # docs:, chore:, ... keep the subject as written
    fi
  else
    other+=("- $subject")           # not a conventional subject at all
  fi
done

# section TITLE BULLET...  -> prints nothing when there are no bullets
section() {
  local title=$1; shift
  (( $# > 0 )) || return 0
  printf '\n### %s\n' "$title"
  printf '%s\n' "$@"
}

echo "## $version"
if (( ${#breaking[@]} + ${#features[@]} + ${#fixes[@]} + ${#other[@]} == 0 )); then
  printf '\nNo changes.\n'
  exit 0
fi
section "Breaking changes" "${breaking[@]+"${breaking[@]}"}"
section "Features" "${features[@]+"${features[@]}"}"
section "Fixes" "${fixes[@]+"${fixes[@]}"}"
section "Other" "${other[@]+"${other[@]}"}"
