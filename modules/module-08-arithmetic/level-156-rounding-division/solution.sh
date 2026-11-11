#!/usr/bin/env bash
# Split AMOUNT ($1) cents between PARTS ($2) customers and show the three ways
# of turning the fraction into whole cents: down, to the nearest, and up.

# TODO: guard PARTS = 0 (stderr + exit 2)
# TODO: floor is what plain integer division already gives
# TODO: nearest: add half of PARTS to the amount before dividing
# TODO: ceiling: add PARTS - 1 to the amount before dividing
