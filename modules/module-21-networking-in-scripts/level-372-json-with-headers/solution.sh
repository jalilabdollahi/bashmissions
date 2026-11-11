#!/usr/bin/env bash
# Raise one invoice through Theo's JSON API.
# POST https://billing.lanternfish.example/api/v1/invoices with a JSON body
# and a header that says the body is JSON.

# TODO: check the argument count, then the amount (digits, optional .NN), then the customer name
# TODO: build the body: {"customer":"...","amount":...} on one line
# TODO: send it with -H for the content type and -d for the body
# TODO: print "reply: <response body>"
