#!/usr/bin/env bash

# The body is written once. Everything between { and } runs each time
# somebody types "rule".
rule() {
  echo "========================"
}

# The definition must come first: Bash reads the script top to bottom and only
# knows a function name after it has passed the definition.
rule
echo "Nightly report: $TITLE"
rule
echo "All servers reporting."
rule
