#!/usr/bin/env bash
# A 30-wide box around $TITLE: border, title row, border.
# TODO: print the border by repeating "=" 30 times (no typing them out),
#       then "| ", the title in a 26-wide field, " |", then the border again.
printf '| %s |\n' "$TITLE"
