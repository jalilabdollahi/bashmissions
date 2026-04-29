#!/usr/bin/env bash
# Name: report-status
# Author: BashMissions
# Usage: report-status [environment]
# Description: Demonstrates a documented script header.
set -euo pipefail

grep -E '^# (Name|Usage|Description):' "$0" | sed 's/^# //'
