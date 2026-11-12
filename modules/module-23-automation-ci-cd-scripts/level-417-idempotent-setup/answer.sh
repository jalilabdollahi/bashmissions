#!/usr/bin/env bash
set -euo pipefail

created=0 present=0
created_it() { created=$(( created + 1 )); echo "created $1"; }
already_ok()  { present=$(( present + 1 )); echo "ok $1"; }

# 1. group: getent's exit status says whether it exists (0 yes, 2 no).
if getent group deploy >/dev/null; then
  already_ok "group deploy"
else
  groupadd deploy
  created_it "group deploy"
fi

# 2. directories
for dir in app/releases app/shared app/logs; do
  if [[ -d $dir ]]; then
    already_ok "dir $dir"
  else
    mkdir -p "$dir"
    created_it "dir $dir"
  fi
done

# 3. seed file: written once, then it belongs to the operator.
config=app/shared/config.env
if [[ -e $config ]]; then
  already_ok "file $config"
else
  echo "PORT=8080" > "$config"
  created_it "file $config"
fi

# 4. one exact line. -x = whole line, -F = plain text (no regex), -q = just the status.
profile=app/profile
line="umask 027"
if [[ -f $profile ]] && grep -qxF -- "$line" "$profile"; then
  already_ok "line $line in $profile"
else
  # If the file does not end with a newline, add one first. $(tail -c1 f) is
  # empty when the last byte is a newline (command substitution strips it).
  if [[ -s $profile && -n $(tail -c1 "$profile") ]]; then
    echo >> "$profile"
  fi
  echo "$line" >> "$profile"
  created_it "line $line in $profile"
fi

# 5. link: -L is true for a symlink even if it dangles; -e alone would not be.
link=app/current-logs
if [[ -L $link ]]; then
  already_ok "link $link"
elif [[ -e $link ]]; then
  echo "conflict: $link exists and is not a link" >&2
  exit 1
else
  ln -s logs "$link"
  created_it "link $link"
fi

echo "setup complete: $created created, $present already in place"
