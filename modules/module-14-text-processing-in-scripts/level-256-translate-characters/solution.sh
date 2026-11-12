#!/usr/bin/env bash
# Turn service names like "tidewater-books.api" into TIDEWATER_BOOKS_API.
# Names arrive on standard input, one per line.

# TODO: one tr call. Its first set lists the characters to replace
# (the lowercase letters, the dot, the dash); its second set lists their
# replacements in the same order.
