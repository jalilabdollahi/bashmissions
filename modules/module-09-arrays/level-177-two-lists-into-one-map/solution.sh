#!/usr/bin/env bash
# Zip two files into a lookup table: line N of HOSTFILE belongs to line N of
# IPFILE. Refuse when the line counts differ. Print "<host>=<ip>" lines
# sorted by host.
if [[ $# -lt 2 ]]; then
  echo "usage: solution.sh HOSTFILE IPFILE" >&2
  exit 2
fi

mapfile -t hosts < "$1"
mapfile -t ips < "$2"

# TODO: if the lengths differ:
#   lists differ in length: <hosts> hosts, <ips> addresses   (stderr, exit 1)

# TODO: zip into an associative array, one shared index for both arrays

# TODO: print host=ip, hosts sorted (sort the KEYS)
for i in "${!hosts[@]}"; do
  echo "${hosts[i]}=${ips[i]}"
done
