#!/usr/bin/env bash
set -euo pipefail
# Switch the "current" symlink to releases/$1, smoke-test it, and put the
# previous release back if the smoke test fails.

# TODO 1: releases/$1 must be a directory (exit 2 otherwise, change nothing).
# TODO 2: read the old link target BEFORE you change anything; the link may be
#         missing on a first deploy.
# TODO 3: already on this release? say so and stop.
# TODO 4: replace the link with ln -sfn, then run smoke-test (survive its failure).
# TODO 5: pass -> report; fail -> restore the old target (or remove the link
#         if there was none) and exit 1.
