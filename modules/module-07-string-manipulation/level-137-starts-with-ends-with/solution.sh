#!/usr/bin/env bash
# Upload filter: ./solution.sh .env id_rsa.pem backup-2024.tar.gz menu.pdf
# Print "<name>: <label>" for each name, using the FIRST rule that fits:
#   starts with "." -> hidden | ends with ".pem" -> quarantine
#   starts with "backup-" -> archive | otherwise accept
# TODO: loop over the names, test them with [[ ]] pattern comparisons in this order.
