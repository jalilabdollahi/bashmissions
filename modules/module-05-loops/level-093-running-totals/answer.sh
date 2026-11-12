#!/usr/bin/env bash
sum=0   # start at zero so an empty report still prints a number

while read -r customer gb; do
  sum=$(( sum + gb ))
  echo "$customer +$gb = $sum"
done

echo "total=$sum"
