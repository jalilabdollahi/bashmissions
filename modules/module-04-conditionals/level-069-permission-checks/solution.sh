#!/usr/bin/env bash
# Pre-flight rights check for the path in $1.
# Missing path -> message on stderr + exit 1.
# Otherwise print "<path>: " and three characters (r/-, w/-, x/-).

# TODO: bail out early if the path does not exist
# TODO: build one character per right: start each as "-" and change it when the test passes
# TODO: print the path and the three characters together
