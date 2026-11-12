#!/usr/bin/env bash
set -euo pipefail

template=${1:-}
if [[ ! -r $template || -d $template ]]; then
  echo "cannot read $template" >&2
  exit 2
fi

# A placeholder at the very start of the text: ${NAME} or ${NAME:-fallback}, then the rest.
# Groups: 1 = NAME, 2 = ":-fallback" (or empty), 3 = fallback text, 4 = remainder.
re='^\$\{([A-Za-z_][A-Za-z0-9_]*)(:-([^}]*))?\}(.*)$'

output=""
missing=()

# Only names that are really in the environment may be looked up. compgen -e
# lists exported variables; our own helpers (line, rest, output...) are not
# exported, so a template cannot read them through ${!name}.
declare -A exported=()
while IFS= read -r env_name; do
  exported[$env_name]=1
done < <(compgen -e)

note_missing() {
  local seen
  for seen in ${missing[@]+"${missing[@]}"}; do
    [[ $seen == "$1" ]] && return 0
  done
  missing+=("$1")
}

while IFS= read -r line || [[ -n $line ]]; do
  rest=$line
  rendered=""

  # Walk the line from left to right. Text that was already handled is never
  # looked at again, so a value containing "${X}" cannot be expanded twice.
  while [[ $rest == *'${'* ]]; do
    rendered+=${rest%%'${'*}            # copy everything before the next "${"
    rest='${'${rest#*'${'}              # put the "${" back at the front of the rest

    if [[ $rest =~ $re ]]; then
      name=${BASH_REMATCH[1]}
      has_fallback=${BASH_REMATCH[2]}
      fallback=${BASH_REMATCH[3]}
      rest=${BASH_REMATCH[4]}

      if [[ -v exported[$name] && -n ${!name} ]]; then   # ${!name}: value of the variable named in $name
        rendered+=${!name}
      elif [[ -n $has_fallback ]]; then
        rendered+=$fallback
      elif [[ -v exported[$name] ]]; then
        :                                           # set but empty and no fallback: renders as nothing
      else
        note_missing "$name"
      fi
    else
      rendered+='${'                                # not a placeholder: keep it literally
      rest=${rest#'${'}
    fi
  done

  output+=$rendered$rest$'\n'
done < "$template"

if (( ${#missing[@]} > 0 )); then
  printf 'missing variable: %s\n' "${missing[@]}" >&2
  exit 1
fi
printf '%s' "$output"
