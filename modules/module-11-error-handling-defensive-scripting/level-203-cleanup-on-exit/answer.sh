#!/usr/bin/env bash
set -e

release_lock() {
  rm -f deploy.lock
  echo "lock released"
}

touch deploy.lock
trap release_lock EXIT   # from here on, however we leave, the lock goes too

lanternbuild
echo "deploy finished"
