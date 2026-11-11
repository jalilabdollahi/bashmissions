#!/usr/bin/env bash
# Is the backup in $2 at least as recent as the source in $1?
# Print the STALE line when the backup is older (or missing), the fresh line otherwise.

# TODO: name the two paths
# TODO: compare the modification times with -nt (or -ot)
# TODO: think about what happens when the backup file does not exist
