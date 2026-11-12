#!/usr/bin/env bash
# Policy enforcer. RULES lists compliance rules (mode, line, noline, setting,
# absent); WAIVERS can silence a rule until an expiry time. `check` reports,
# `enforce` fixes and re-verifies, `--dry-run` shows what enforce would do.
#   solution.sh [--dry-run] check|enforce ROOT RULES NOW [WAIVERS]

# TODO: arguments (--dry-run only with enforce), readable files, NOW is an integer
# TODO: parse RULES, list every bad line "rules line N: ..." before exiting 2
# TODO: parse WAIVERS into id -> until, reason
# TODO: mode_of PATH: turn the rwx letters of `ls -ld` into an octal string
# TODO: evaluate ID: one function per rule type, setting a failure message
# TODO: can_fix, fix_text, apply_fix (with a cp -p backup of the original first)
# TODO: main loop: waived? pass? check -> FAIL; enforce -> CANNOT FIX / WOULD FIX / FIXED / STILL FAILING
# TODO: summary line and exit status
