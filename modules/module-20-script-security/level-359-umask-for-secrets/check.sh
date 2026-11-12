#!/usr/bin/env bash
# Permissions are checked with find -perm (portable across macOS and Linux).
[[ $BM_EXIT == 0 ]] || exit 0
name=$1
key="secrets/$name.key"
if [[ -z $(find "$key" -perm 600 2>/dev/null) ]]; then
  echo "$key must have mode 600 (owner read/write only)."
  exit 1
fi
if [[ $BM_TEST_NAME == "secrets folder already exists" ]]; then
  : # the folder was created by the test with default permissions; leave it
elif [[ -z $(find secrets -maxdepth 0 -perm 700 2>/dev/null) ]]; then
  echo "A secrets folder created by your script must have mode 700."
  exit 1
fi
if [[ -z $(find index.txt -perm -004 2>/dev/null) ]]; then
  echo "index.txt must stay world-readable: apply the umask only around the secret part (a subshell)."
  exit 1
fi
exit 0
