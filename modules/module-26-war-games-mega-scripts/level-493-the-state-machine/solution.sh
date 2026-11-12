#!/usr/bin/env bash
# Incident-ticket state machine. The rules live in MACHINE (initial/final states
# and "FROM EVENT TO [role=..] [require=..]" transitions); the TICKET file holds
# one ticket's state, fields and history.
#   solution.sh MACHINE validate | show TICKET | fire TICKET EVENT ROLE [FIELD=VALUE...]

# TODO: usage and argument counts per mode, readable MACHINE
# TODO: parse the machine: initial, final, transitions with role= / require= options
#       bad lines -> "MACHINE:LINE: bad line", exit 2; duplicates: first one wins
# TODO: transition table in associative arrays keyed "FROM|EVENT"; events per state
# TODO: validate: breadth-first reachability, dead ends, final states with exits
# TODO: read the ticket (missing file = new ticket in the initial state)
# TODO: show: state, allowed events, steps, fields
# TODO: fire: illegal / denied / blocked checks IN THIS ORDER, then temp file + mv
