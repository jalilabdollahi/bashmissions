#!/usr/bin/env bash
# stdin: "<customer> <gigabytes>" per line. Print a taxi-meter line per customer
# and "total=N" at the end.
# TODO: start a sum at 0, add each line's gigabytes, print the meter line.
while read -r customer gb; do
  echo "$customer +$gb = $gb"
done
echo "total=0"
