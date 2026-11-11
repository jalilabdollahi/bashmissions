#!/usr/bin/env bash
# Rotate a log when it grows past MAXBYTES, keeping KEEP numbered old copies.
# shop.log -> shop.log.1 -> shop.log.2 ... the oldest falls off the end.

# TODO: arguments and "no such log" check
# TODO: size in bytes, then compare with the limit
# TODO: if too big, move copies up (highest number first!), then recreate the log
