#!/usr/bin/env bash
# printf reuses its format for every extra argument. {1..30} expands to
# thirty numbers, and '=%.0s' prints one "=" per number (the number itself
# is swallowed by %.0s, "print zero characters of this string").

printf '=%.0s' {1..30}; printf '\n'
printf '| %-26s |\n' "$TITLE"
printf '=%.0s' {1..30}; printf '\n'
