#!/usr/bin/env bash
# Audit an iptables-save export: find default-allow policy, sensitive ports and
# port ranges open to the world, and "accept everything" rules in INPUT.

# TODO: usage, readable file, and a quick check that it contains a *filter table
# TODO: walk the file line by line (awk keeps NR as the line number)
# TODO: for -A INPUT rules, walk the fields to learn -s, -i, -p, -m, --dport(s) and -j
# TODO: apply the predicates, print one finding per problem
# TODO: count rules and findings, print the tally, exit 1 when there are findings
