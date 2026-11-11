#!/usr/bin/env bash
# Job wrapper: stdin lines get a "JOB: " prefix, go to the screen AND to the end
# of a log file, and a "finished" line closes each run.

# TODO: usage check, then check that the log's folder exists
# TODO: loop over stdin, counting lines
# TODO: send every prefixed line to the screen and to the log without erasing it
