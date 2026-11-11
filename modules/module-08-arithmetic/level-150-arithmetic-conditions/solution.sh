#!/usr/bin/env bash
# Traffic light for a disk: NAME ($1), USED ($2), TOTAL ($3), sizes in GB.
# Print "<NAME>: OK", "<NAME>: WARNING" or "<NAME>: CRITICAL".

# TODO: name the three arguments
# TODO: first check the 90% line, then the 75% line (the order matters)
# TODO: compare used * 100 against total * 90 / total * 75 inside (( ))
# TODO: print the right word
