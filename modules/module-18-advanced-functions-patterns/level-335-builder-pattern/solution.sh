#!/usr/bin/env bash
set -euo pipefail
# VM order builder. solution.sh NAME [cpus=N] [ram_gb=N] [disk_gb=N] [region=R]
# Collect options one setter at a time, then build and print the spec.

# TODO 1: no NAME -> usage on stderr, exit 2.
# TODO 2: declare -A spec; vm_new NAME fills in the defaults.
# TODO 3: with_cpus, with_ram_gb, with_disk_gb, with_region: validate the value, store it,
#         or print "with_X: invalid value 'V'" on stderr and return 1.
# TODO 4: build: ram_gb must be at least 2 * cpus, else error and return 1; otherwise print the five lines.
# TODO 5: loop over KEY=VALUE arguments (split with ${arg%%=*} and ${arg#*=}), call the matching
#         setter, then build. Any failure: exit 2. Unknown key: message, exit 2.
