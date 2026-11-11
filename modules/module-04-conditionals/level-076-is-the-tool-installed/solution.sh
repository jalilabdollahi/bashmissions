#!/usr/bin/env bash
# Pre-flight check for setup scripts: is the tool named in $1 installed?
# Installed -> print "found: <its --version output>".
# Missing   -> "missing: <tool>" on stderr, exit 1. No argument -> usage, exit 2.

# TODO: refuse to run without an argument (usage on stderr, exit 2)
# TODO: ask Bash whether the tool can be found, keeping the answer silent
# TODO: found -> run the tool with --version and print it after "found: "
# TODO: not found -> message on stderr, exit 1
