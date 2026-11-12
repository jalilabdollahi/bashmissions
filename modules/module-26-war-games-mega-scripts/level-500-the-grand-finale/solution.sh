#!/usr/bin/env bash
# lantern: one command for the person on call.
#   solution.sh version | health [SERVICES] | backups TODAY [DIR] | report TODAY
#               | handover TODAY PERSON
# Dates are YYYYMMDD and always passed in (TODAY); nothing reads the clock.

# TODO: usage text, and a dispatcher on the first argument
# TODO: valid_date: real calendar dates only (leap years: divisible by 4, not by 100 unless by 400)
# TODO: days_of YYYYMMDD: days since 1970 with integer maths ("days from civil")
# TODO: health: curl each service, classify the status code, print and count
# TODO: backups: newest backup per name, age in days, CORRUPT / NOSUM / STALE / ok
# TODO: report: both of the above under one heading, then a GREEN / AMBER / RED verdict
# TODO: handover: only when GREEN; update oncall.txt and handover.log; say goodbye
