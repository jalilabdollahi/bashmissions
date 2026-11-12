#!/usr/bin/env bash
# A greeter that re-reads its config when it receives HUP. A helper called
# confpush will rewrite the file and send the signal; this script has to be
# ready for it, react, and then notice that the reload happened.

# TODO: usage error (stderr, exit 2) when CONF is missing
# TODO: a function that reads the greeting= line into $greeting
# TODO: load it, print "loaded greeting=..."
# TODO: trap a handler on HUP (reload, reloaded=1, print "reloaded greeting=...")
# TODO: THEN start confpush "$$" "$conf" &
# TODO: poll 20 x (sleep 0.1) until reloaded=1; report success or failure
