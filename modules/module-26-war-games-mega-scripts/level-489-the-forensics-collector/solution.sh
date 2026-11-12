#!/usr/bin/env bash
# Evidence collector with a chain of custody. `collect` copies, fingerprints and
# locks files into a case folder and seals the manifest; `verify` proves later
# that nothing was changed, removed or added.
#   solution.sh collect CASE ANALYST NOW SRC... | verify CASE ANALYST NOW

# TODO: usage + NOW must be a non-negative integer
# TODO: collect: refuse an existing CASE; skip non-regular sources; nothing left = error
# TODO: copy with cp -p to evidence/NNN-name, compare cksum of source and copy
# TODO: chmod 0444 the copies; write manifest.txt (NAME SUM SIZE SRC) and manifest.seal
# TODO: append to custody.log: "NOW ANALYST collect N items"
# TODO: verify: seal check, then MISSING / MODIFIED / WRITABLE / OK per manifest line
# TODO: list EXTRA files in evidence/ that the manifest does not know
# TODO: summary line, custody entry, exit 1 when there were problems
