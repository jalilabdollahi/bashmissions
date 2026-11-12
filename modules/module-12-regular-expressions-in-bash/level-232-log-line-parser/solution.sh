#!/usr/bin/env bash
# Brute-force report from sshd lines on stdin. For every IP with 3+ failed logins
# print "BLOCK <ip> failures=<n> last-user=<user> last-seen=<HH:MM:SS>" (IPs in
# sort order) and, below it, an ALERT line when that IP logged in successfully
# after it already had 3+ failures. Everything else is ignored.
# TODO: two anchored regexes (Failed ..., Accepted ...) with groups; one of them
# TODO: has an optional "invalid user " group, so count the groups carefully
# TODO: associative arrays: failures, last user, last time, alert user (keyed by IP)
# TODO: after the loop, sort the IPs and print the report
while IFS= read -r line || [[ -n $line ]]; do
  :
done
