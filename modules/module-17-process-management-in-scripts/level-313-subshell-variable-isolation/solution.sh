#!/usr/bin/env bash
set -euo pipefail

value="parent"
( value="child"; echo "inside=$value" )
echo "outside=$value"
