#!/usr/bin/env bash
# Nightly backup. DB_HOST is required: with no host there is nothing to
# dump, and the job must not pretend otherwise.

# TODO: print "backup job starting"
# TODO: read DB_HOST into host - or stop with "DB_HOST must be set" (exit 1)
# TODO: print "dumping database on <host>"
