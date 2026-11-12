#!/usr/bin/env bash
# lantern 1.3.0, served by updates.lanternfish.example
case ${1:-} in
  version) echo "lantern 1.3.0" ;;
  *) echo "lantern 1.3.0: storm rota ready" ;;
esac
