#!/usr/bin/env bash
# Label printer numbers: how many servers did we get, and how many
# characters wide is the first server's name?
fleet=("$@")

# TODO: servers: the number of ELEMENTS in the array
# TODO: first tag width: the number of CHARACTERS in element 0
echo "servers: ${#fleet}"
echo "first tag width: 0"
