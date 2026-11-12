#!/usr/bin/env bash
# Usage: solution.sh OLD NEW
# Print "+ name" for customers only in NEW, then "- name" for customers only
# in OLD. Each group sorted.

# TODO 1: comm compares two SORTED inputs. Sort both files (process substitution).
# TODO 2: ask comm for the lines unique to the second file (suppress columns 1 and 3),
#         then for the lines unique to the first (suppress 2 and 3).
# TODO 3: put "+ " or "- " in front of each line with sed.
