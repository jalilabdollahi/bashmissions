#!/usr/bin/env bash
# Config manager: merge schema defaults, layer files, environment variables and
# --set overrides (in that order), validate against the schema, then show, get or
# export the result. Secrets are masked unless --reveal is given.
#   solution.sh [--layer FILE]... [--set KEY=VALUE]... [--prefix P] [--reveal] SCHEMA COMMAND [ARG]

# TODO: option parsing and command validation (usage -> exit 2); unreadable files -> exit 2
# TODO: read the schema into arrays: ordered keys, type, default, flags
# TODO: apply the layers lowest to highest, remembering each value's source
#       (files: key = value with trimming and quote removal; env: PREFIX_KEY_NAME via ${!name}; --set)
# TODO: collect load problems first (unknown key, bad line, bad --set), then validate in schema order
#       (required, int, port, bool normalisation, enum)
# TODO: print every problem as "config error: ..." on stderr and exit 1 before any normal output
# TODO: commands: validate, show (masked secrets), get, export env / shell / json
