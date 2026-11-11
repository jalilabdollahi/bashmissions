#!/usr/bin/env bash
# Short names for the on-call rota. Input: one host name per line on stdin.
# Output per line: "<full name>  =>  <short name>"  (two spaces around the arrow).
# TODO: read the lines in a loop (the last one may lack a newline).
# TODO: keep only the part before the FIRST dot using a suffix-removing expansion.
