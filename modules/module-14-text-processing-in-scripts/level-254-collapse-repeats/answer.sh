#!/usr/bin/env bash
set -euo pipefail

# uniq only compares each line with the one just before it, which is exactly
# what a state-change timeline needs. No sorting: that would group all the
# OKs together and lose the story.
uniq "$1"
