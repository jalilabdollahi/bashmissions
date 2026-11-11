#!/usr/bin/env bash
# The bundle is what leaves the building: it must not hold the secret, but it
# must still show the harmless settings (so the whole environment was not wiped).
[[ $BM_EXIT == 0 ]] || exit 0
token=$(sed -n 's/^Authorization: Bearer //p' request.txt)
if [[ -z $token ]]; then
  echo "request.txt has no 'Authorization: Bearer ...' line."
  exit 1
fi
if grep -F -q -- "$token" bundle.txt; then
  echo "bundle.txt still contains the token: unset it before running support-bundle."
  exit 1
fi
if grep -q '^API_TOKEN=' bundle.txt; then
  echo "bundle.txt still lists API_TOKEN."
  exit 1
fi
if ! grep -q '^REGION=' bundle.txt; then
  echo "bundle.txt lost the REGION setting: forget only the secret, not everything."
  exit 1
fi
exit 0
