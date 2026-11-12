#!/usr/bin/env bash
# New-customer tool with named flags, in any order:
#   --customer NAME  (required)   --plan NAME (default basic)   --dry-run (switch)
# Parse them yourself: look at the first argument, handle it, shift it away, repeat.
# TODO: defaults, the parsing loop, the "no customer" check, the summary line.
