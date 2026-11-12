#!/usr/bin/env bash
# Security scanner: permission checks with find, config checks with plain Bash.
set -euo pipefail

usage() {
  echo "usage: solution.sh [--fail-on LEVEL] ROOT [ALLOWLIST]" >&2
  exit 2
}

level=high
if [[ ${1:-} == --fail-on ]]; then
  [[ $# -ge 2 ]] || usage
  level=$2
  shift 2
fi
case $level in critical|high|medium) ;; *) usage ;; esac
[[ $# -eq 1 || $# -eq 2 ]] || usage
root=${1%/}
allowlist=${2:-}
[[ -d $root ]] || { echo "not a directory: $root" >&2; exit 2; }
if [[ -n $allowlist && ! -r $allowlist ]]; then
  echo "cannot read $allowlist" >&2
  exit 2
fi

declare -A allowed
if [[ -n $allowlist ]]; then
  while read -r p _; do
    [[ -z $p || $p == \#* ]] && continue
    allowed[$p]=1
  done < "$allowlist"
fi

findings=()
# add RANK SEVERITY PATH MESSAGE: the rank makes `sort` put CRITICAL first.
add() { findings+=("$1 $2 $3: $4"); }
rel() { printf '%s' "${1#"$root"/}"; }

# 1. world-writable regular files (-perm -0002 = the "others write" bit is set)
while IFS= read -r f; do
  add 2 HIGH "$(rel "$f")" "world-writable file"
done < <(find "$root" -type f -perm -0002)

# 2. private keys: -perm -MODE needs ALL bits, so ask for each of the six bits.
while IFS= read -r f; do
  add 1 CRITICAL "$(rel "$f")" "private key accessible by group or others"
done < <(find "$root" -type f \( -name '*.key' -o -name id_rsa -o -name id_ed25519 -o -name id_ecdsa \) \
           \( -perm -0040 -o -perm -0020 -o -perm -0010 -o -perm -0004 -o -perm -0002 -o -perm -0001 \))

# 3. setuid / setgid files that nobody vouched for
while IFS= read -r f; do
  [[ -n ${allowed[$(rel "$f")]:-} ]] && continue
  add 2 HIGH "$(rel "$f")" "setuid/setgid binary not on allowlist"
done < <(find "$root" -type f \( -perm -4000 -o -perm -2000 \))

# 4. sshd_config: first occurrence of a key wins, keys are case-insensitive
sshd=$root/etc/ssh/sshd_config
if [[ -r $sshd ]]; then
  declare -A seen
  while read -r key val _; do
    [[ -z $key || $key == \#* ]] && continue
    key=${key,,}
    [[ -n ${seen[$key]:-} ]] && continue
    seen[$key]=${val,,}
  done < "$sshd"
  [[ ${seen[permitemptypasswords]:-} == yes ]] && add 1 CRITICAL "$(rel "$sshd")" "ssh accepts empty passwords"
  [[ ${seen[permitrootlogin]:-} == yes ]] && add 2 HIGH "$(rel "$sshd")" "ssh root login enabled"
  [[ ${seen[passwordauthentication]:-} == yes ]] && add 3 MEDIUM "$(rel "$sshd")" "ssh password login enabled"
fi

# 5. credentials in config files (location only, never the value)
cred_re='^[[:space:]]*[a-z0-9_.-]*(password|passwd|secret|token|api_key)[a-z0-9_.-]*[[:space:]]*[:=][[:space:]]*(.*)$'
while IFS= read -r f; do
  n=0
  while IFS= read -r line || [[ -n $line ]]; do
    n=$((n + 1))
    lower=${line,,}
    [[ $lower =~ $cred_re ]] || continue
    value=${BASH_REMATCH[2]}
    value=${value%"${value##*[![:space:]]}"}
    case $value in
      ''|'""'|"''"|\$*|\<*|\#*) continue ;;
    esac
    add 3 MEDIUM "$(rel "$f")" "plaintext credential on line $n"
  done < "$f"
done < <(find "$root" -type f \( -name '*.conf' -o -name '*.env' -o -name '*.ini' -o -name '*.yml' \))

# --- report ----------------------------------------------------------------
crit=0 high=0 med=0
if (( ${#findings[@]} > 0 )); then
  while IFS= read -r line; do
    case $line in
      "1 "*) crit=$((crit + 1)) ;;
      "2 "*) high=$((high + 1)) ;;
      "3 "*) med=$((med + 1)) ;;
    esac
    echo "${line#* }"
  done < <(printf '%s\n' "${findings[@]}" | LC_ALL=C sort)
fi
echo "scan complete: $crit critical, $high high, $med medium"

case $level in
  critical) (( crit == 0 )) ;;
  high)     (( crit + high == 0 )) ;;
  medium)   (( crit + high + med == 0 )) ;;
esac
