#!/usr/bin/env bash
set -euo pipefail
# Container release: build IMAGE:VERSION once, add the moving tags for stable
# versions, then push every tag. Pre-releases only ever get their own tag.

# TODO 1: validate IMAGE and VERSION (X.Y.Z with optional -suffix); CONTEXT
#         defaults to ".".
# TODO 2: docker build with --build-arg VERSION=... and -t IMAGE:VERSION;
#         if it fails, say "build failed" and exit 1 (no tags, no pushes).
# TODO 3: a stable version (no suffix) also gets IMAGE:MAJOR.MINOR and
#         IMAGE:latest through docker tag.
# TODO 4: push each tag in creation order, printing "pushed ..." after each;
#         stop at the first push that fails.
