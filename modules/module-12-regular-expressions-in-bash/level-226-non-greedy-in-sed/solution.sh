#!/usr/bin/env bash
set -euo pipefail

text='a123b a456b'
echo "$text" | sed 's/a[^b]*b/X/'
