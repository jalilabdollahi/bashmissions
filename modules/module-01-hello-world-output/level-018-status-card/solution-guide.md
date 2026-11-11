# Walkthrough: Status Card

## The plan
Nothing in this level is new; it is the first time the tools work together. Each part of the card has one tool that suits it, and the order of the script is the order of the output, with the exit status last.

## Step by step
1. The header is two lines of mostly fixed text with one variable in it. A here-document is the right tool: `cat <<EOF`, the two lines, `EOF`. `$SERVER` is expanded because the marker is not quoted.
2. The numbers need columns. `printf '%-12s %5d\n'` left-aligns the label in 12 characters and right-aligns the number in 5. Run it once per row.
3. The note about who printed the card is not part of the card, so it goes to standard error: `echo "..." >&2`. The script name comes from `$(basename "$0")`.
4. The collector decides the status, so the script ends with `exit "$STATUS_CODE"`. Because `exit` stops the script, it must be the last line.

## Complete solution

```bash
#!/usr/bin/env bash
cat <<EOF
=== STATUS CARD: $SERVER ===
Region: harbour-east
EOF

printf '%-12s %5d\n' "uptime days" "$UPTIME"
printf '%-12s %5d\n' "open alerts" "$ALERTS"

echo "$(basename "$0"): card printed for $SERVER" >&2
exit "$STATUS_CODE"
```

## Trying it by hand
`SERVER=anchovy UPTIME=118 ALERTS=3 STATUS_CODE=1 bash solution.sh 2>/dev/null; echo "status $?"` shows the card without the note, then the status.

## An alternative
You could build every line with `printf`, header included. It would work, but the here-document keeps the layout of the header visible in the code, and mixing tools by purpose is what makes scripts readable.
