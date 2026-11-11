# Common Mistakes

- **Deciding on every line.** Wrong: a `case` inside the loop repeats the choice per amount and mixes the rule with the loop. Right: set `strategy=` once before the loop.
- **Storing the result instead of the name.** Wrong: `strategy=$(round_up 1201)` stores `13`. Right: `strategy=round_up`, call it later.
- **Forgetting the quotes or the dollar.** Wrong: `strategy "$cents"` runs a command literally named `strategy`. Right: `"$strategy" "$cents"`.
- **Wrong ceiling.** Wrong: `$(( $1 / 100 + 1 ))` turns exactly 1200 into 13. Right: `$(( ($1 + 99) / 100 ))`.
- **Letting `read` choke on junk.** Wrong: doing arithmetic on `abc` or `12.50` fails the whole run (or treats `abc` as 0). Right: test `[[ $cents =~ ^[0-9]+$ ]]` first, report, continue.
