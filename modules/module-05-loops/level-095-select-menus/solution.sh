#!/usr/bin/env bash
# Night-shift menu: 1) anchovy 2) barracuda 3) cuttlefish 4) quit
# TODO: use select; handle a valid server, quit, and unknown choices ($REPLY).
read -r choice
echo "restarting $choice"
