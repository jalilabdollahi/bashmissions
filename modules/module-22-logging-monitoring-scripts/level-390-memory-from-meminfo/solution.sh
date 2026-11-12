#!/usr/bin/env bash
# Memory report from a /proc/meminfo-style file (values in kB).
# used = MemTotal - available; available falls back to MemFree+Buffers+Cached.

# TODO: check arguments, readability, and that MemTotal exists
# TODO: read "Name: value kB" lines into an associative array
# TODO: compute MiB and percentages with integer arithmetic
# TODO: print memory and swap lines, then the optional WARN line
