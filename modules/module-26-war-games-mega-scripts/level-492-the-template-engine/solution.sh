#!/usr/bin/env bash
# A tiny template engine for generated configs.
#   solution.sh [-D NAME=VALUE]... TEMPLATE VARS
# Markup: {{name}} / {{name:-fallback}}, and block lines
#   {% if COND %} ... {% else %} ... {% endif %}   {% for x in LIST %} ... {% endfor %}

# TODO: options (-D), files readable, usage
# TODO: read VARS into an associative array (bad line -> "bad vars line N", exit 2)
# TODO: classify every template line: text or directive; match if/else/endif and
#       for/endfor with a stack; collect structural errors, print them sorted, exit 1
# TODO: render(start, end) recursively; plain lines get their {{placeholders}} replaced
# TODO: for loops: set the item and loop.index, restore the old values afterwards
# TODO: collect output in a variable and print it only if rendering succeeded
