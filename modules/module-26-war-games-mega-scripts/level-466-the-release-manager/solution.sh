#!/usr/bin/env bash
# Release manager: decide the next version from the commit subjects, write the
# changelog, package dist/, tag the release and announce it. All or nothing.
#   solution.sh [--dry-run] [--notify URL] APP

# TODO: parse --dry-run / --notify, require APP (exit 2)
# TODO: preflight: clean tree (git status --porcelain), latest tag (git describe), vX.Y.Z check
# TODO: read subjects with git log, exit 4 when there are none
# TODO: classify subjects with a regex: type(scope)!: text -> breaking / feat / fix / other
# TODO: compute the next version (major / minor / patch rule)
# TODO: check dist/ is not empty; in --dry-run print the plan and the changelog section and stop
# TODO: tarball + sums in releases/, new changelog written beside the old one
# TODO: git tag last; on failure delete what you made (exit 5); then move the changelog in place
# TODO: optional webhook announcement (a failure is only a warning), final summary lines
