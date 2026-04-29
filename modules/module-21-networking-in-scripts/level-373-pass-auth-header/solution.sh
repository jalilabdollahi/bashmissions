#!/usr/bin/env bash
set -euo pipefail
token='secret-token'
header="Authorization: Bearer $token"
[[ $header == Authorization:* ]] && echo 'auth_header=ready'
