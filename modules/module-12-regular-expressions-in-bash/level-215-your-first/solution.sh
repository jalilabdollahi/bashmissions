#!/usr/bin/env bash
# Read sshd lines from stdin. Print "ALERT: <line>" for every line that contains
# the text "Failed password" anywhere, and print nothing for the others.
# TODO: loop over the lines with while IFS= read -r line
# TODO: ask [[ $line =~ ... ]] whether the line contains the text, and echo if it does
