#!/usr/bin/env bash
# Label racks 08..12 as <prefix>-NN, one per line. The prefix is $1.
# TODO: reject a missing prefix, then loop over the range of rack numbers.
echo "$1-01"
