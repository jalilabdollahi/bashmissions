#!/usr/bin/env bash
# Billing run: print "billing <code>" for each code in the arguments,
# but skip accounts whose code starts with TEST-.
# TODO: inside the loop, skip test accounts before the billing line.
for code in "$@"; do
  echo "billing $code"
done
