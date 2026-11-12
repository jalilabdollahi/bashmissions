#!/usr/bin/env bash
# ./solution.sh SITE   run the shared report, but with Eel Street's own rules.
# The shared library is fixtures/defaults.sh (cat it first).
# TODO: source the library, then override retention_days (90) and notify ("[ops-desk] ...").
# TODO: call the library's report with the site name; no site -> usage, exit 2.
