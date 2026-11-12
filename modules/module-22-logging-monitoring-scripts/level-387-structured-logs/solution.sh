#!/usr/bin/env bash
# Emit one structured log line:  time=... level=... msg="..." key=value ...
# Fields that need it (spaces, quotes) are quoted so a parser can split them.

# TODO: validate arguments and the level word
# TODO: time comes from NOW, or from the clock when NOW is unset
# TODO: build the line piece by piece, then print it once
