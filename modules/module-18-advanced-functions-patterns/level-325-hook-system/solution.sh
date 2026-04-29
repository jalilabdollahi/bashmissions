#!/usr/bin/env bash
set -euo pipefail

pre(){ echo pre; }
post(){ echo post; }
declare -a pre_hooks=(pre) post_hooks=(post)
for hook in "${pre_hooks[@]}"; do "$hook"; done
echo main
for hook in "${post_hooks[@]}"; do "$hook"; done
