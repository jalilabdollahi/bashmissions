#!/usr/bin/env bash
# Nightly security scanner: weak permissions and risky settings under ROOT.
# Findings are ranked CRITICAL > HIGH > MEDIUM; the exit status says whether
# anything at or above --fail-on LEVEL (default high) was found.
#   solution.sh [--fail-on LEVEL] ROOT [ALLOWLIST]

# TODO: parse --fail-on, validate LEVEL, ROOT (a directory) and ALLOWLIST
# TODO: load the allowlist of expected setuid/setgid files into an array
# TODO: a helper that records a finding with a rank so `sort` orders by severity
# TODO: find world-writable files, weak private keys, unlisted setuid/setgid files
# TODO: read etc/ssh/sshd_config the way sshd does (first value wins)
# TODO: find plaintext credentials in *.conf / *.env / *.ini / *.yml, no values printed
# TODO: sorted report, summary line, exit status according to LEVEL
