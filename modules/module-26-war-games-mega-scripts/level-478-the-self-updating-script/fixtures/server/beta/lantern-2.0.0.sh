#!/usr/bin/env bash
# lantern 2.0.0, served by updates.lanternfish.example
case ${1:-} in
  version) echo "lantern 2.0.0" ;;
  *) echo "lantern 2.0.0: storm rota ready" ;;
esac
