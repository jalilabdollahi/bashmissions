#!/usr/bin/env bash
# \033[32m switches the terminal to green, \033[0m switches back to normal.
# The colour only applies to what is printed between the two codes.
printf '\033[32mOK\033[0m %s responds in time\n' "$SERVICE"
printf '\033[33mWARN\033[0m %s responds slowly\n' "$SERVICE"
printf '\033[31mFAIL\033[0m %s does not respond\n' "$SERVICE"
