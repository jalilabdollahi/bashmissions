#!/usr/bin/env bash
# App settings resolver: environment first, defaults last.
# Inputs (all optional): APP_NAME, APP_MODE, APP_PORT, PORT, APP_WORKERS.
# Resolve each setting into a variable, then print the five-line block.

# TODO: name, mode, workers - the environment value or the default
# TODO: port - APP_PORT, else PORT, else 8080
# TODO: print name=, mode=, port=, workers=, listen=name:port
