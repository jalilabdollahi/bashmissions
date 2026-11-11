#!/usr/bin/env bash
# Ollie's script: reuses slugify from solution.sh by sourcing it.
here=$(cd "$(dirname "$0")" && pwd)
source "$here/../solution.sh"
echo "sourced ok"
case $- in
  *e*) echo "bad: errexit leaked into the caller" ;;
esac
echo "slug: $(slugify 'North Pier Dental')"
