#!/usr/bin/env bash
# $0 is whatever path was used to start the script (it may include folders),
# so basename trims it down to the file name. Quotes protect spaces in paths.
echo "This script is called $(basename "$0")"
echo "Report file: $(basename "$REPORT_PATH")"
