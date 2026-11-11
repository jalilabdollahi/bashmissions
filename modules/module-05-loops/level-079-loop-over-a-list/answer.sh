#!/usr/bin/env bash
# Each round of the loop puts the next word of the list into $name.
for name in anchovy barracuda cuttlefish dory eel; do
  echo "refreshing banner on $name"
done
# This line is after "done", so it runs once, when the loop is over.
echo "all banners refreshed"
