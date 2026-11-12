#!/usr/bin/env bash
# On-call rota: person 1 -> Mon, person 2 -> Tue ... person 8 -> Mon again.
# TODO: keep the days in an array, walk the people with an index, wrap with %.
days=(Mon Tue Wed Thu Fri Sat Sun)
echo "${days[0]}: $1"
