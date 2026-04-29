#!/usr/bin/env bash
set -euo pipefail

stages=(build test)
stages+=(production)
echo "${stages[*]}"
