#!/usr/bin/env bash
# Token audit. ${TOKEN+set} expands to "set" when TOKEN exists at all (even
# if it is empty) and to nothing when it does not exist.

echo "before=[${TOKEN+set}]"
unset TOKEN
echo "after=[${TOKEN+set}]"
