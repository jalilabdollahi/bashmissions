#!/usr/bin/env bash
# Dependency resolver for the Lanternfish fleet. GRAPH lines read
# "NAME: dep dep ...", dependencies start first.
#   solution.sh levels|order|stop GRAPH [TARGET...] | check GRAPH
# Kahn's algorithm, layer by layer; a layer is sorted alphabetically.

# TODO: usage, mode check, readable GRAPH
# TODO: parse into associative arrays; collect ALL problems with GRAPH:LINE: prefixes
# TODO: unknown dependencies, duplicates, bad names -> exit 2 after listing them
# TODO: targets: keep the targets plus everything they depend on (a stack walk)
# TODO: count unmet dependencies; keep a reverse map "dependents" per service
# TODO: loop: all nodes with zero unmet form the next layer; release their dependents
# TODO: nodes left over mean a cycle: walk to find it and print "cycle detected: ..."
# TODO: print levels / order / reverse order / the check summary
