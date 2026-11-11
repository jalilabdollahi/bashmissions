#!/usr/bin/env bash
# Fetch the monthly report. When the API says "429, wait N seconds" (in the
# Retry-After header), wait exactly that long and ask again, up to 4 tries.

# TODO: temp files for the headers and the body, removed on exit
# TODO: loop over attempts 1..4; per attempt call curl with -D, -o and -w '%{http_code}'
# TODO: on 429, pull the number out of the Retry-After line (any case, strip the \r),
#       default to 1, and sleep -- unless this was the last attempt
# TODO: 200 prints the body; other codes and giving up are errors on stderr (exit 1)
