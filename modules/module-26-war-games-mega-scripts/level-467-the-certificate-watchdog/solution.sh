#!/usr/bin/env bash
# Certificate watchdog: classify every CERTDIR/*.pem with openssl, optionally renew
# the ones that are close to expiry (with a limit), reload nginx once, report.
#   solution.sh [--warn DAYS] [--crit DAYS] [--renew] [--max-renewals N] CERTDIR

# TODO: parse the options (exit 64 on mistakes), check CERTDIR and that it holds *.pem files
# TODO: inspect(): -enddate first (INVALID?), then -checkend 0 / crit / warn seconds
# TODO: loop over the certificates: inspect, renew candidates (certbot) while attempts < max,
#       inspect again after a success, remember a note per certificate
# TODO: print the table with the exact printf format
# TODO: a single systemctl reload nginx if any renewal succeeded
# TODO: summary line and exit status 2 / 1 / 0
