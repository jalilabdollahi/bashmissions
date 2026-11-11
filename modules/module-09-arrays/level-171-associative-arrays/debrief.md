# Debrief: Associative Arrays

An associative array is a variable whose keys are strings. `declare -A` creates it, `map[key]=value` fills it, and `${map[key]}` reads it. It is Bash's dictionary.

## How it works
Indexed arrays and associative arrays are two different types, and you choose the type at declaration. Bash cannot guess: given `x[dory]=Priya` and no `-A`, it treats `dory` as an arithmetic expression, which evaluates to 0. The element lands in `x[0]` and there is no error. This is the most common map bug and always starts with a missing `declare -A`.

Inside the map, lookups are by hash, so finding a key takes the same time for ten entries or ten million. This is why a map replaces the "search the array in a loop" pattern of the earlier levels.

Keys are unique. Assigning to a key that exists overwrites its value, which makes "latest wins" configuration loading trivial. And the order of keys when you iterate is not defined by insertion or by alphabet: it looks random. If your output needs an order, you must sort it yourself, the topic of two levels from now.

Associative arrays need Bash 4 or later. The `/bin/bash` that ships with older macOS is version 3.2 and has none, so scripts that use maps start with a modern bash.

## In real work
Server-to-owner, hostname-to-IP, extension-to-handler tables, and any "lookup by name" configuration.

## Going further
Next you will use a map for counting: the same structure, driven by a different question.
