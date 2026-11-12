#!/usr/bin/env bash
# Package audit: compare what dpkg-query says is installed with a policy
# of require / forbid / minver rules.

# TODO: usage and policy readability
# TODO: load "name version" pairs from dpkg-query into an associative array
# TODO: pre-check the policy for unknown rule words (nothing printed yet)
# TODO: a helper that cuts a version down to its leading digits and dots
# TODO: a helper that compares two dotted versions numerically
# TODO: apply the rules in order; print MISSING / FORBIDDEN / OUTDATED lines
# TODO: summary and exit status
