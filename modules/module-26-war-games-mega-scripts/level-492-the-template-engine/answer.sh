#!/usr/bin/env bash
# Tiny template engine: {{vars}}, {% if %}, {% for %}. Parse structure first,
# then render recursively into a buffer, and print only if everything was valid.
set -euo pipefail

usage() {
  echo "usage: solution.sh [-D NAME=VALUE]... TEMPLATE VARS" >&2
  exit 2
}

declare -A vars
overrides=()
while [[ ${1:-} == -D ]]; do
  [[ $# -ge 2 ]] || usage
  [[ $2 =~ ^[A-Za-z_][A-Za-z0-9_]*= ]] || { echo "bad -D option" >&2; exit 2; }
  overrides+=("$2")
  shift 2
done
[[ $# -eq 2 ]] || usage
tpl=$1 varfile=$2
for f in "$tpl" "$varfile"; do
  [[ -r $f ]] || { echo "cannot read $f" >&2; exit 2; }
done

# --- variables ------------------------------------------------------------
n=0
while IFS= read -r line || [[ -n $line ]]; do
  n=$((n + 1))
  [[ $line =~ ^[[:space:]]*(#|$) ]] && continue
  if [[ ! $line =~ ^([A-Za-z_][A-Za-z0-9_]*)=(.*)$ ]]; then
    echo "bad vars line $n" >&2
    exit 2
  fi
  vars[${BASH_REMATCH[1]}]=${BASH_REMATCH[2]}
done < "$varfile"
for o in "${overrides[@]}"; do vars[${o%%=*}]=${o#*=}; done

# --- read the template and classify every line -----------------------------
lines=()
kind=()      # text | if | else | endif | for | endfor
arg=()
else_of=()
end_of=()
errors=()
err() { errors+=("$(printf '%06d' "$1") line $1: $2"); }

trim() {
  local s=$1
  s=${s#"${s%%[![:space:]]*}"}
  s=${s%"${s##*[![:space:]]}"}
  printf '%s' "$s"
}

stack=()
i=0
while IFS= read -r line || [[ -n $line ]]; do
  lines[i]=$line
  kind[i]=text
  lineno=$((i + 1))
  if [[ $line =~ ^[[:space:]]*\{%(.*)%\}[[:space:]]*$ ]]; then
    d=$(trim "${BASH_REMATCH[1]}")
    word=${d%%[[:space:]]*}
    rest=$(trim "${d#"$word"}")
    top=-1
    (( ${#stack[@]} == 0 )) || top=${stack[${#stack[@]} - 1]}
    case $word in
      if)
        if [[ -z $rest ]]; then err "$lineno" "bad directive '$d'"; else
          kind[i]=if; arg[i]=$rest; stack+=("$i")
        fi ;;
      else)
        if (( top >= 0 )) && [[ ${kind[top]} == if ]]; then
          kind[i]=else; else_of[top]=$i
        else
          err "$lineno" "'else' without 'if'"
        fi ;;
      endif)
        if (( top >= 0 )) && [[ ${kind[top]} == if ]]; then
          kind[i]=endif; end_of[top]=$i; unset 'stack[${#stack[@]}-1]'
        else
          err "$lineno" "'endif' without 'if'"
        fi ;;
      for)
        if [[ $rest =~ ^([A-Za-z_][A-Za-z0-9_]*)[[:space:]]+in[[:space:]]+([A-Za-z_][A-Za-z0-9_]*)$ ]]; then
          kind[i]=for; arg[i]="${BASH_REMATCH[1]} ${BASH_REMATCH[2]}"; stack+=("$i")
        else
          err "$lineno" "bad directive '$d'"
        fi ;;
      endfor)
        if (( top >= 0 )) && [[ ${kind[top]} == for ]]; then
          kind[i]=endfor; end_of[top]=$i; unset 'stack[${#stack[@]}-1]'
        else
          err "$lineno" "'endfor' without 'for'"
        fi ;;
      *) err "$lineno" "bad directive '$d'" ;;
    esac
    # a directive that failed to classify still must not print
    [[ ${kind[i]} == text ]] && kind[i]=skip
  fi
  i=$((i + 1))
done < "$tpl"
total=$i
for idx in "${stack[@]:-}"; do
  [[ -n $idx ]] && err "$((idx + 1))" "unclosed '${kind[idx]}'"
done
if (( ${#errors[@]} > 0 )); then
  printf '%s\n' "${errors[@]}" | LC_ALL=C sort -s -k1,1 | cut -d' ' -f2- >&2
  exit 1
fi

# --- rendering -------------------------------------------------------------
buffer=
runtime_error=

truthy() {   # NAME -> 0 when set and not empty/0/false/no/off
  local v=${vars[$1]:-}
  v=${v,,}
  [[ -n $v && $v != 0 && $v != false && $v != no && $v != off ]]
}

eval_cond() {   # COND -> exit status like a test
  local c=$1 left op right
  if [[ $c =~ ^not[[:space:]]+([A-Za-z_][A-Za-z0-9_.]*)$ ]]; then
    ! truthy "${BASH_REMATCH[1]}"
  elif [[ $c =~ ^([A-Za-z_][A-Za-z0-9_.]*)[[:space:]]*(==|!=)[[:space:]]*(.+)$ ]]; then
    left=${vars[${BASH_REMATCH[1]}]:-} op=${BASH_REMATCH[2]} right=${BASH_REMATCH[3]}
    if [[ $op == == ]]; then [[ $left == "$right" ]]; else [[ $left != "$right" ]]; fi
  elif [[ $c =~ ^[A-Za-z_][A-Za-z0-9_.]*$ ]]; then
    truthy "$c"
  else
    runtime_error="bad condition"
    return 1
  fi
}

# substitute LINENO TEXT -> sets $subst, or $runtime_error
substitute() {
  local lineno=$1 rest=$2 out= expr name fallback val
  while [[ $rest == *"{{"* ]]; do
    out+=${rest%%\{\{*}
    rest=${rest#*\{\{}
    if [[ $rest != *"}}"* ]]; then
      runtime_error="line $lineno: unclosed '{{'"
      return 1
    fi
    expr=$(trim "${rest%%\}\}*}")
    rest=${rest#*\}\}}
    name=${expr%%:-*}
    fallback=
    has_fallback=0
    if [[ $expr == *":-"* ]]; then fallback=${expr#*:-}; has_fallback=1; fi
    name=$(trim "$name")
    val=${vars[$name]:-}
    if [[ -z $val ]]; then
      if (( has_fallback )); then
        val=$fallback
      elif [[ -z ${vars[$name]+set} ]]; then
        runtime_error="line $lineno: undefined variable '$name'"
        return 1
      fi
    fi
    out+=$val
  done
  subst=$out$rest
}

render() {   # START END (exclusive)
  local s=$1 e=$2 j item list item_var list_var idx saved_item saved_idx had_item had_idx else_j end_j
  j=$s
  while (( j < e )); do
    [[ -z $runtime_error ]] || return 1
    case ${kind[j]} in
      text)
        substitute $((j + 1)) "${lines[j]}" || return 1
        buffer+=$subst$'\n'
        j=$((j + 1)) ;;
      skip) j=$((j + 1)) ;;
      if)
        end_j=${end_of[j]}
        else_j=${else_of[j]:-}
        if eval_cond "${arg[j]}"; then
          render $((j + 1)) "${else_j:-$end_j}" || return 1
        elif [[ -n $else_j ]]; then
          render $((else_j + 1)) "$end_j" || return 1
        fi
        [[ -z $runtime_error ]] || { runtime_error="line $((j + 1)): $runtime_error"; return 1; }
        j=$((end_j + 1)) ;;
      for)
        read -r item_var list_var <<< "${arg[j]}"
        end_j=${end_of[j]}
        if [[ -z ${vars[$list_var]+set} ]]; then
          runtime_error="line $((j + 1)): undefined variable '$list_var'"
          return 1
        fi
        had_item=${vars[$item_var]+set}; saved_item=${vars[$item_var]:-}
        had_idx=${vars[loop.index]+set};  saved_idx=${vars[loop.index]:-}
        IFS=, read -ra list <<< "${vars[$list_var]}"
        idx=0
        for item in "${list[@]}"; do
          idx=$((idx + 1))
          vars[$item_var]=$item
          vars[loop.index]=$idx
          render $((j + 1)) "$end_j" || return 1
        done
        if [[ -n $had_item ]]; then vars[$item_var]=$saved_item; else unset "vars[$item_var]"; fi
        if [[ -n $had_idx ]]; then vars[loop.index]=$saved_idx; else unset 'vars[loop.index]'; fi
        j=$((end_j + 1)) ;;
      *) j=$((j + 1)) ;;   # else / endif / endfor are consumed by their block
    esac
  done
}

if ! render 0 "$total"; then
  echo "${runtime_error:-render failed}" >&2
  exit 1
fi
printf '%s' "$buffer"
