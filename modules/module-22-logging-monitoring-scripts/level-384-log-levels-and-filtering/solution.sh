#!/usr/bin/env bash
# Log filter: stdin lines look like "LEVEL message"; LOG_LEVEL is the threshold.
# Keep the lines at least as important as the threshold, skip unknown levels.

# TODO: give each level a number (ERROR is the most important)
# TODO: read LOG_LEVEL (default INFO) and reject unknown words
# TODO: loop over stdin, compare the line's number with the threshold's
