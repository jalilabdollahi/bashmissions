#!/usr/bin/env bash
set -euo pipefail
# Derive the build version from "git describe": tag + commits since + hash.
# On the tag exactly -> plain version; otherwise a -dev.N+gHASH version.

# TODO 1: run git describe with the exact flags from the objective and capture
#         its output; if the command fails, take the fallback branch.
# TODO 2: fallback: version=0.0.0-dev+g<short hash from git rev-parse>.
# TODO 3: parse the output FROM THE RIGHT with one regex (tag may hold hyphens):
#         tag, distance, hash, optional -dirty.
# TODO 4: distance 0 and clean -> tag without the v; else -dev.N+gHASH(.dirty).
# TODO 5: an output that does not look like vX.Y.Z... -> error on stderr, exit 1.
