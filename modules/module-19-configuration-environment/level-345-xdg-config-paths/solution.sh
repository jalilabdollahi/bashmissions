#!/usr/bin/env bash
set -euo pipefail
# Where is the config file of application $1? Look in the XDG location first
# (XDG_CONFIG_HOME, or ~/.config when it is unset/empty/relative), then in the
# legacy ~/.APPrc. Print "config: PATH", showing ~ for the home directory.

# TODO 1: require the APP argument (usage message, exit 2).
# TODO 2: work out the base directory: use XDG_CONFIG_HOME only if it starts with /.
# TODO 3: try the candidates in order; the first regular file wins.
# TODO 4: print it with the home prefix replaced by ~, or fail with exit 1.
