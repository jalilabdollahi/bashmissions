#!/usr/bin/env bash
# Quota tool, step one: look at the value before trusting it.
# Digits only is fine; anything else is rejected with a message on stderr and
# exit status 1, and nothing is printed to stdout.
# TODO: test $1 against a digits-only pattern, then act on the result.
