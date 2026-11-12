#!/usr/bin/env bash
# Canary controller. For every step of PLAN: set the traffic share, soak, then
# judge the observed error rates from METRICS. Any bad sign pulls the canary
# back to 0%. The last step (100) promotes the release.
#   solution.sh PLAN METRICS RELEASE
# Settings from the environment: SOAK, MIN_REQS, TOLERANCE_PM.

# TODO: usage + validate SOAK, MIN_REQS, TOLERANCE_PM and that files are readable
# TODO: read and validate the plan (increasing, ends at 100) BEFORE any lbctl call
# TODO: load METRICS into associative arrays keyed by step
# TODO: rate in permille with integer maths, and a formatter for "2.5%"
# TODO: set_weight that rolls back and exits 3 when lbctl fails
# TODO: abort STEP REASON: weight 0, message on stdout, exit 1
# TODO: the loop: weight, sleep, judge (missing data, sample size, tolerance)
# TODO: step 100: weight, promote, final message
