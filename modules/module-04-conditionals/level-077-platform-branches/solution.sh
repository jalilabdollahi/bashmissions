#!/usr/bin/env bash
# Print the command that counts CPU cores on this platform.
# Linux -> nproc, Darwin (macOS) -> sysctl -n hw.ncpu, anything else -> unsupported.

# TODO: capture the system name with uname -s
# TODO: choose between the platforms (if/elif or case, your call)
# TODO: unsupported platforms: message on stderr, exit 1
