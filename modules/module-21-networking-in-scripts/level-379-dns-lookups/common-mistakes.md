# Common Mistakes

- **Using `-short` instead of `+short`.** dig's query options start with a plus sign; `-short` is rejected.
  - Right: `dig +short "$name"`
- **Trusting the exit status for "does it exist".** An unknown name makes dig exit 0 with no output.
  - Right: test whether the output is empty.
- **Keeping the alias line.** Without a filter the CNAME target `shop.lanternfish.example.` ends up in your list of addresses.
  - Right: `grep -E '^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$'`
- **A grep that finds nothing killing the script.** Under `set -euo pipefail`, grep's exit status 1 aborts the loop.
  - Right: `... | grep ... || true`
- **Forgetting the quotes around the name.** An empty or odd argument changes what dig is asked: `dig +short $name` with an empty `$name` queries the root servers.
