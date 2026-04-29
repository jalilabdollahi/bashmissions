#!/usr/bin/env bash
set -euo pipefail

message() {
  echo "old"
}

message

message() {
  echo "new"
}

message
