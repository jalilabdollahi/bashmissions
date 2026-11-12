#!/usr/bin/env bash
# Quota lookup. quota_var holds a variable NAME; ${!quota_var} follows it
# and gives the value of the variable with that name.

quota_var=LIMIT_$CUSTOMER

echo "quota for $CUSTOMER: ${!quota_var:-unlimited}"
