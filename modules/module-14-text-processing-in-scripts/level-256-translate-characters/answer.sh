#!/usr/bin/env bash
set -euo pipefail

# tr pairs the characters of the two sets by position:
#   a-z -> A-Z,  '.' -> '_',  '-' -> '_'
# The dash is last in the first set so tr reads it as a plain character.
tr 'a-z.-' 'A-Z__'
