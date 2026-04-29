#!/usr/bin/env bash
set -euo pipefail

{ diff -u fixtures/old.conf fixtures/new.conf || true; } | grep '^[+-]port=' | sed 's/^- /old: /; s/^-/old:/; s/^+/new:/'
