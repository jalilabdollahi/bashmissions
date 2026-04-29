#!/usr/bin/env bash
set -euo pipefail

sed -e 's/error/ERROR/' -e '/skip/d' fixtures/data.txt
