# Debrief: Does the Key Exist?

A map can answer two different questions: "what is the value?" and "is there a value at all?". Empty is a value; missing is an absence.

## How it works
Reading `${map[$k]}` for a missing key gives an empty string, exactly like reading a key whose value is empty. Default operators such as `:-` inherit the same blindness: they replace both. To tell them apart, test the key itself with `[[ -v map[$k] ]]`.

This distinction is not pedantic. "Timeout is empty" can mean "no timeout", while "timeout is missing" means "use the default". Configuration, environment variables and feature flags all have this three-state shape: unset, set but empty, set to something.

Two practical notes. Under `set -u`, reading a missing key as `${map[$k]}` is an "unbound variable" error, so checking with `-v` before reading is also the safe way to write strict scripts. And the plain-variable form of the same test is `[[ -v NAME ]]`, which tells you whether a variable exists, regardless of its content.

The `${var+word}` expansion (word if set, nothing otherwise) is the older spelling of the same idea. You will meet it in existing scripts.

## In real work
Merging settings with defaults, validating required options, "was this flag passed at all?".

## Going further
Next you will remove a key, and see why setting it to empty is not the same thing.
