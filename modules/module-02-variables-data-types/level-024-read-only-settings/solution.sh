#!/usr/bin/env bash
# Retention guard for Priya. KEEP_DAYS is the real setting, NEW_DAYS is a
# careless later change that must be refused.

# TODO: create RETENTION_DAYS from KEEP_DAYS and lock it
# TODO: print "retention: N days"
# TODO: attempt RETENTION_DAYS=$NEW_DAYS
# TODO: print "retention now: N days" (it must still show the original value)
