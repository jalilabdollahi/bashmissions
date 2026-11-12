# Common Mistakes

- **Forgetting `shift` in a branch.** `--dry-run) dry_run=yes ;;` never advances,
  so `$1` stays `--dry-run` and the loop runs forever. Right:
  `--dry-run) dry_run=yes; shift ;;`.
- **Shifting one for a flag with a value.** `--plan) plan=$2; shift ;;` leaves
  `harbour` behind, and the next round reports `unknown option: harbour`. Right:
  `shift 2`.
- **No catch-all branch.** Without `*)`, a typo like `--plam x` is silently
  ignored. Add `*) echo "error: unknown option: $1" >&2; exit 2 ;;`.
- **Missing `;;` between branches.** Bash reports a syntax error near the next
  pattern. End each branch with `;;`.
