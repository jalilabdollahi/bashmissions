#!/usr/bin/env bash
# Print every invoice id of a customer. The API gives them out one page at
# a time and each page says where the next one is (or that there is none).

# TODO: usage check; build the base URL for the customer's invoices
# TODO: start with next="?page=1" and loop while next is not empty
# TODO: each round: fetch base+next, print the ids from "items", count them,
#       then read the new "next" value (null means: stop)
# TODO: guard against more than 10 pages; fail cleanly when a page cannot be fetched
# TODO: finish with "total: N"
