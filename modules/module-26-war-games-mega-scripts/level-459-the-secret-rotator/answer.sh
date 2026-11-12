#!/usr/bin/env bash
# Secret rotator: new secret -> database -> config -> verify, or roll everything back.
set -euo pipefail

map=rotation.map
dry=0
if [[ ${1:-} == --dry-run ]]; then
  dry=1
  shift
fi
if [[ ! -r $map ]]; then
  echo "error: cannot read rotation.map" >&2
  exit 2
fi

declare -A cfg_of key_of user_of
order=()
while IFS='|' read -r name cfg key user; do
  [[ -z $name || $name == \#* ]] && continue
  cfg_of[$name]=$cfg
  key_of[$name]=$key
  user_of[$name]=$user
  order+=("$name")
done < "$map"

if (( $# == 0 )); then
  targets=("${order[@]}")
else
  targets=("$@")
fi
for n in "${targets[@]}"; do
  if [[ -z ${cfg_of[$n]:-} ]]; then
    echo "error: unknown secret $n" >&2
    exit 2
  fi
done

# write_config FILE KEY VALUE: replace the KEY= line, same mode, atomic mv.
# The value travels in the environment, so it never shows up in `ps`.
write_config() {
  local cfg=$1 key=$2 tmp
  tmp=$(mktemp "$cfg.XXXXXX")
  cp -p "$cfg" "$tmp"
  NEWVALUE=$3 awk -F= -v k="$key" '
    $1 == k { print k "=" ENVIRON["NEWVALUE"]; next }
    { print }
  ' "$cfg" > "$tmp"
  mv "$tmp" "$cfg"
}

# rotate_one NAME: returns 1 and sets $reason when something goes wrong.
reason=
rotate_one() {
  local name=$1 cfg=${cfg_of[$1]} key=${key_of[$1]} user=${user_of[$1]}
  local secret_file=secrets/$1.secret old new bak
  reason=
  if [[ ! -r $secret_file ]]; then
    reason="no current secret on disk"
    return 1
  fi
  old=$(<"$secret_file")
  if ! grep -q "^$key=" "$cfg" 2> /dev/null; then
    reason="config has no $key"
    return 1
  fi
  new=$(vault-gen "$name")
  if ! dbctl set-password "$user" "$new" > /dev/null 2>&1; then
    reason="database refused the new password"
    return 1
  fi
  bak=$cfg.rotate-bak
  cp -p "$cfg" "$bak"
  write_config "$cfg" "$key" "$new"
  if ! dbctl check "$user" "$new" > /dev/null 2>&1; then
    mv "$bak" "$cfg"
    dbctl set-password "$user" "$old" > /dev/null 2>&1 || true
    reason="verification failed, old secret restored"
    return 1
  fi
  rm -f "$bak"
  (umask 077; printf '%s\n' "$new" > "$secret_file")
  chmod 600 "$secret_file"
}

ok=()
bad=()
for name in "${targets[@]}"; do
  if (( dry )); then
    echo "would rotate $name: ${cfg_of[$name]} ${key_of[$name]} (db user ${user_of[$name]})"
    continue
  fi
  if rotate_one "$name"; then
    echo "rotate $name: ok"
    echo "$name ok" >> rotation.log
    ok+=("$name")
  else
    echo "rotate $name: FAILED ($reason)"
    echo "$name failed: $reason" >> rotation.log
    bad+=("$name")
  fi
done

if (( dry )); then
  exit 0
fi
echo "rotated: ${ok[*]:-none}"
echo "failed: ${bad[*]:-none}"
[[ ${#bad[@]} -eq 0 ]] || exit 1
