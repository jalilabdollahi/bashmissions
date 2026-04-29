# Print a Banner

`printf` borrows its format syntax from C. The most useful field specifier for shell scripts is `%s` (string), with optional **width** and **alignment**:

| Format    | "hi" → output    | "longer" → output |
|-----------|------------------|--------------------|
| `%s`      | `hi`             | `longer`           |
| `%10s`    | `        hi`     | `    longer`       |
| `%-10s`   | `hi        `     | `longer    `       |
| `%.3s`    | `hi`             | `lon` (truncated)  |
| `%-10.10s`| `hi        `     | `longer    `       |

Key rule: **width is a minimum, never a maximum**. A string longer than the field prints in full and the columns no longer line up. To enforce a hard cap, use `.N` (precision) — `%-10.10s` left-aligns *and* truncates.

```bash
printf '== %-10s ==\n' hi          # == hi         ==
printf '== %-10s ==\n' BashMission # == BashMission ==   (overflow)
printf '== %-10.10s ==\n' BashMission # == BashMissio ==  (truncated)
```

Banners, log columns, status tables, and CLI usage strings all lean on padded `%s`.
