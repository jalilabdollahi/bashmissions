#!/bin/bash
# Theo's line counter. Prints the number of lines in the file given as $1.

# TODO 1: replace line 1 with the portable shebang (env finds bash on PATH).
# TODO 2: add a "# Description: ..." comment near the top.
# TODO 3: add strict mode so a missing file or argument stops the script.

n=$(cat $1 | wc -l | tr -d ' ')
echo "lines: $n"
echo "done"
