#!/usr/bin/env bash
set -euo pipefail

# uname -s prints the kernel name: "Linux" on Linux, "Darwin" on macOS.
os="$(uname -s)"

if [[ $os == Linux ]]; then
  echo "cpu count: nproc"
elif [[ $os == Darwin ]]; then
  echo "cpu count: sysctl -n hw.ncpu"
else
  echo "unsupported platform: $os" >&2
  exit 1
fi
