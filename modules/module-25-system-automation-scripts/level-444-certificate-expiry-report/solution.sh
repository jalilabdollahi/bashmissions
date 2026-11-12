#!/usr/bin/env bash
# Certificate expiry report: for every NAME.pem in a folder, how many days are
# left as of TODAY (given as YYYY-MM-DD)? Sorted, with a status word.

# TODO: validate arguments (usage and the shape of TODAY)
# TODO: a helper that turns Y M D into a single day number
# TODO: for each .pem: ask openssl for notAfter, split it into month, day, year
# TODO: map the month name to a number, subtract day numbers
# TODO: sort numerically, print with the exact printf layout, then the summary line
