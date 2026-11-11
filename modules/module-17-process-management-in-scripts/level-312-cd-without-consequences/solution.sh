#!/usr/bin/env bash
# Build every site folder given as an argument with `sitebuild`, which works on
# the folder it is run from. Your own working directory must stay put.

# TODO: usage error (stderr, exit 2) without arguments
# TODO: start=$PWD
# TODO: for each folder: if ( cd "$dir" && sitebuild ); then ...built...; else ...failed...; fi
# TODO: count the successes, print "built A of N sites"
# TODO: report whether $PWD still equals $start; exit 1 if any site failed
