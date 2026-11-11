#!/usr/bin/env bash
domain=$1

# &> is "both stdout and stderr" in one go. Because it is ONE file opened ONE
# time and shared by both descriptors, the lines stay in the order written.
cert-check "$domain" &> cert.log

# wc pads its number on macOS; arithmetic strips the spaces.
lines=$(( $(wc -l < cert.log) ))
echo "saved $lines lines"
