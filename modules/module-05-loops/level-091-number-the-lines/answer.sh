#!/usr/bin/env bash
days=(Mon Tue Wed Thu Fri Sat Sun)
people=("$@")   # copy the arguments into an array so we can use positions

for (( i = 0; i < ${#people[@]}; i++ )); do
  # i counts 0,1,2,...; i % 7 counts 0..6 and then starts over.
  day=${days[ i % ${#days[@]} ]}
  echo "$day: ${people[i]}"
done
