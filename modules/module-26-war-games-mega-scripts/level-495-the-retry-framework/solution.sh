#!/usr/bin/env bash
# Retry wrapper with three back-off strategies.
#   solution.sh plan STRATEGY ATTEMPTS DELAY [MAX]
#   solution.sh run [--strategy S] [--attempts N] [--delay D] [--max-delay M]
#                   [--budget B] [--retry-on C,C] -- COMMAND [ARGS...]
# Waits after failed attempt N: fixed D, linear D*N, exponential D*2^(N-1).

# TODO: usage text and validation of strategy / attempts / numbers
# TODO: wait_after STRATEGY DELAY MAX N: the three formulas, cap, 86400 hard limit
# TODO: plan: print one line per wait and the total
# TODO: run: parse options up to `--`, then loop over the attempts
# TODO: keep the command's exit status; decide: success / not retryable / last attempt
# TODO: compute the wait, check the budget, report to stderr, call sleep (not for 0)
