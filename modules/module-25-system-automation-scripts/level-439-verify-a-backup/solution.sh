#!/usr/bin/env bash
# Check a backup folder against its MANIFEST (lines "CRC SIZE NAME").
# Report OK / FAILED / MISSING per entry, then files nobody listed.

# TODO: usage check, then make sure DIR/MANIFEST exists
# TODO: read the manifest line by line, splitting into crc, size, name
# TODO: for each name decide: missing? matching? failed? (cksum < file gives "CRC SIZE")
# TODO: afterwards list files in DIR that are not in the manifest
# TODO: print the summary; exit 1 if anything failed or is missing
