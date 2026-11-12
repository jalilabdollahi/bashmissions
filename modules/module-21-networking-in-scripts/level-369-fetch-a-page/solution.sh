#!/usr/bin/env bash
# Ask the Lanternfish status page about one component and print a one-line answer.
# The page lives at https://status.lanternfish.example/components/NAME.txt

# TODO: exactly one argument, otherwise usage on stderr and exit 2
# TODO: fetch the page quietly and keep the text in a variable
# TODO: if curl could not even connect, say "status page unreachable" on stderr and exit 1
# TODO: print "NAME: text", or "NAME: no data" when the text is empty
