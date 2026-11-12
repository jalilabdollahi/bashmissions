#!/usr/bin/env bash
# Trim the padding off exported fields. Input: one field per line on stdin.
# Output: each line inside [ ], with leading/trailing blanks removed.
# TODO: enable extended patterns with shopt.
# TODO: read each line WITHOUT letting read trim it for you, then strip both ends.
