#!/usr/bin/env bash
# Back up one directory into DEST/NAME-STAMP.tar.gz and report how many
# files went in. Never overwrite an earlier archive.

# TODO: check the argument count (usage, exit 2) and that SRC is a directory (exit 1)
# TODO: work out NAME (last component of SRC) and the PARENT folder
# TODO: mkdir -p the destination, refuse if the archive path already exists
# TODO: tar the folder so paths inside start with NAME/
# TODO: list the archive back and count entries that are not directories
