# Common Mistakes

- **Trusting `$?` after a pipe.** Wrong: `fetchlog x | sort; echo $?` shows sort's status only. Right: set pipefail first, or read `${PIPESTATUS[0]}` immediately.
- **Setting pipefail after the pipeline.** Wrong: `a | b` on line 5, `set -o pipefail` on line 9. Right: before the first pipeline you care about.
- **Forgetting grep's status 1.** With pipefail, `grep ERROR log | wc -l` returns 1 when the log has no errors. Right: `{ grep ERROR log || true; } | wc -l`, if "no match" is fine.
- **Adding `set -e` to "fix" it.** set -e does not look inside pipes either; without pipefail there is still no failure to react to.
- **Redirecting the wrong way.** `fetchlog x | sort -u > summary.txt` puts the file at the end of the pipeline. A leftover half-written summary.txt after a failure is expected; check status before using the file.
