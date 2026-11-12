#!/usr/bin/env bash
# Inventory card for the server "anchovy".

# No spaces around "=": that is how Bash tells an assignment from a command.
server=anchovy
rack=$RACK

# A leading $ reads the value back.
echo "server: $server"
echo "rack: $rack"
