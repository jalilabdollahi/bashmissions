#!/usr/bin/env bash
# $( ... ) runs the command first and pastes its output into the text.
echo "Oldest: $(head -n 1 fixtures/queue.txt)"
echo "Newest: $(tail -n 1 fixtures/queue.txt)"
