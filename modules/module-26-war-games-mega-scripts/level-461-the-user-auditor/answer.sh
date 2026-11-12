#!/usr/bin/env bash
# User auditor: orphans, stale accounts, shared root powers and sloppy key permissions.
set -euo pipefail

usage() {
  echo "usage: solution.sh [--stale-days N] [--ignore USER]... PASSWD SHADOW LASTLOG" >&2
  exit 2
}

stale=90
declare -A skip
while (( $# > 0 )); do
  case $1 in
    --stale-days)
      if [[ ! ${2:-} =~ ^[0-9]+$ ]]; then
        echo "error: --stale-days needs a whole number" >&2
        exit 2
      fi
      stale=$2
      shift 2
      ;;
    --ignore)
      [[ -n ${2:-} ]] || usage
      skip[$2]=1
      shift 2
      ;;
    -*) usage ;;
    *) break ;;
  esac
done
[[ $# -eq 3 ]] || usage
passwd=$1 shadow=$2 lastlog=$3
for f in "$passwd" "$shadow" "$lastlog"; do
  if [[ ! -r $f ]]; then
    echo "error: cannot read $f" >&2
    exit 2
  fi
done

declare -A hash lastseen uid_owner homedirs
while IFS=: read -r u h _; do
  [[ -z $u || $u == \#* ]] && continue
  hash[$u]=$h
done < "$shadow"
while IFS='|' read -r u d; do
  [[ -z $u || $u == \#* ]] && continue
  lastseen[$u]=$d
done < "$lastlog"

findings=()
# add RANK KIND USER DETAIL
add() {
  local sev
  case $1 in 1) sev=CRIT ;; 2) sev=WARN ;; *) sev=INFO ;; esac
  findings+=("$1|$2|$3|$sev|$4")
}

# Permissions come from `ls -l` (first 10 characters), which is the same on every OS.
mode_of() { ls -l "$1" | cut -c1-10; }

check_home_files() {
  local user=$1 dir=$2 f m
  for f in .ssh/id_rsa .netrc; do
    [[ -f $dir/$f ]] || continue
    m=$(mode_of "$dir/$f")
    [[ ${m:4:6} == "------" ]] || add 1 BADPERM "$user" "$f is $m"
  done
  f=.ssh/authorized_keys
  if [[ -f $dir/$f ]]; then
    m=$(mode_of "$dir/$f")
    if [[ ${m:5:1} == w || ${m:8:1} == w ]]; then
      add 2 BADPERM "$user" "$f is $m"
    fi
  fi
}

while IFS=: read -r user _ uid _ _ home shell; do
  [[ -z $user || $user == \#* ]] && continue
  if [[ $home == /home/* ]]; then
    dir=home/${home#/home/}
    homedirs[$dir]=1
  else
    dir=
  fi
  # The first line with a uid owns it, even when that user is on the ignore list.
  first=${uid_owner[$uid]:-}
  [[ -n $first ]] || uid_owner[$uid]=$user
  [[ -z ${skip[$user]:-} ]] || continue

  if [[ $uid == 0 && $user != root ]]; then
    add 1 UID0 "$user" "uid 0 but not root"
  fi
  if [[ -n $first ]]; then
    add 2 DUPUID "$user" "uid $uid shared with $first"
  fi

  (( uid >= 1000 )) || continue
  if [[ $shell != *nologin && $shell != *false ]]; then
    if [[ -n ${hash[$user]+set} && -z ${hash[$user]} ]]; then
      add 1 NOPASS "$user" "no password set"
    fi
    days=${lastseen[$user]:-never}
    if [[ $days == never ]]; then
      add 2 STALE "$user" "never logged in"
    elif (( days > stale )); then
      add 2 STALE "$user" "last login $days days ago"
    fi
  fi
  if [[ -n $dir ]]; then
    if [[ -d $dir ]]; then
      check_home_files "$user" "$dir"
    else
      add 2 NOHOME "$user" "home $home missing"
    fi
  fi
done < "$passwd"

for d in home/*/; do
  d=${d%/}
  [[ -d $d ]] || continue
  [[ -n ${homedirs[$d]:-} ]] || add 3 ORPHAN "${d##*/}" "home directory has no account"
done

printf '%-5s %-8s %-10s %s\n' SEV KIND USER DETAIL
crit=0 warn=0 info=0
if (( ${#findings[@]} > 0 )); then
  printf '%s\n' "${findings[@]}" | sort -t'|' -k1,1n -k2,2 -k3,3 |
    awk -F'|' '{
      d = $5
      for (i = 6; i <= NF; i++) d = d "|" $i
      printf "%-5s %-8s %-10s %s\n", $4, $2, $3, d
    }'
  for f in "${findings[@]}"; do
    case ${f%%|*} in 1) crit=$((crit + 1)) ;; 2) warn=$((warn + 1)) ;; *) info=$((info + 1)) ;; esac
  done
fi
echo "findings: $crit crit, $warn warn, $info info"
(( crit + warn + info == 0 )) || exit 1
