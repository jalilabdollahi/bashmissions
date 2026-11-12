#!/usr/bin/env bash
set -euo pipefail
# Create and publish the release tag for version $1 - but only when it is safe:
# valid version, clean working tree, tag not used yet.

# TODO 1: accept 1.5.0 or v1.5.0; build tag="v1.5.0". Anything else: exit 2
#         before touching git.
# TODO 2: "git status --porcelain" prints nothing on a clean tree.
# TODO 3: ask git whether refs/tags/$tag already exists (throw its output away).
# TODO 4: create the annotated tag with message "Release $tag".
# TODO 5: push it to origin; if that fails explain how to remove the local tag.
