# Common Mistakes

- **Calling a total a gauge, or the reverse.** Wrong: `# TYPE lanternfish_http_requests_total gauge`. The monitoring server cannot compute rates from it. Totals that only grow are `counter`; snapshots such as "largest now" are `gauge`.
- **Sorting codes as text.** Wrong: `sort` puts `1000` before `200`. Right: `sort -n` for numeric order.
- **Writing directly to the final file.** Symptom: now and then the dashboard shows a dip to zero, because a scrape hit the half-written file. Write `$out.tmp` and `mv` it into place.
- **Missing quotes around label values.** Wrong: `requests_total{code=200} 3` is rejected. Right: `requests_total{code="200"} 3`, which is what `printf '{code="%s"}'` produces.
- **An empty log printing blanks.** Wrong: awk's `END { print bytes }` prints an empty line when nothing matched, making `bytes` empty. Right: `print bytes + 0`.
