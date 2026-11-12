#!/usr/bin/env bash
# lantern 1.4.9, served by updates.lanternfish.example
case ${1:-} in
  version) echo "lantern 1.4.9" ;;
  *) echo "lantern 1.4.9: storm rota ready" ;;
esac
