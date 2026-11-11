#!/usr/bin/env bash
# Inventory card: a line like "anchovy 10.0.0.5 database" arrives on stdin.
# Split it into host, address and role with one read, and print the role first.
# Careful: a role may be several words long.
# TODO: read the three fields, then print "role=... host=... address=...".
