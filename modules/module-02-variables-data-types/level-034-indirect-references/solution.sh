#!/usr/bin/env bash
# Quota lookup for the support desk.
# Quotas are stored in settings called LIMIT_<customer>, for example
# LIMIT_bakery=50. CUSTOMER says which one to read.

# TODO: build the NAME of the variable (LIMIT_ plus the customer) in quota_var
# TODO: look up the value of the variable that quota_var names
# TODO: print "quota for <customer>: <value>" ("unlimited" if nothing is there)
