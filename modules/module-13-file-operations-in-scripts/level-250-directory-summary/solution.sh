#!/usr/bin/env bash
# Count the regular files under FOLDER per extension and print
#   EXT: COUNT      (biggest first, ties alphabetical)
#   total: N files
# Extension = lowercase text after the last dot of the file NAME; names with
# no usable extension are counted as (none).

# TODO: argument and folder checks
# TODO: declare -A count; loop over the files that find prints
# TODO: take the bare name off the path, then decide: extension or (none)?
# TODO: print the table sorted by count (desc) then name (asc), then the total
