#!/usr/bin/env bash
# Blue-green switcher. ROOT/releases/{blue,green} hold releases, ROOT/current is
# a symlink to the live one. `switch` flips it atomically after a smoke test,
# `rollback` flips it back.
#   solution.sh ROOT status | switch | rollback

# TODO: usage() and argument checks
# TODO: find the live slot: read the link target with `ls -ld`, validate it
# TODO: version SLOT: contents of VERSION or "none"
# TODO: point_current SLOT: ln -sfn to a temp name, then rename over `current`
#       (watch out: mv onto a symlink to a directory moves INTO the directory)
# TODO: status: two lines
# TODO: switch: version checks, smoke-test, flip, previous + switch.log
# TODO: rollback: use `previous`, flip, update previous + log
# TODO: leave no temp files behind (trap)
