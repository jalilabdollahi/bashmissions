#!/usr/bin/env bash
# select prints the menu and the PS3 prompt on stderr and reads from stdin.
PS3="restart which server? "

select server in anchovy barracuda cuttlefish quit; do
  case $server in
    quit)
      break
      ;;
    "")
      # Not a valid number: $server is empty and $REPLY holds the raw text.
      echo "unknown choice: $REPLY"
      ;;
    *)
      echo "restarting $server"
      ;;
  esac
done
# select itself returns 1 when the input ends; a clean menu session is a success.
exit 0
