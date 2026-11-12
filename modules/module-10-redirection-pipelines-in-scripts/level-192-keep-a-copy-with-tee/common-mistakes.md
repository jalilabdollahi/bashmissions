# Common Mistakes

- **Forgetting `-a`.** Every run replaces the log.
  - Wrong: `deploy-tool "$site" 2>&1 | tee deploy.log`
  - Right: `... | tee -a deploy.log`
- **Leaving stderr out of the pipe.** The warning shows on screen but not in the log.
  - Wrong: `deploy-tool "$site" | tee -a deploy.log`
  - Right: `deploy-tool "$site" 2>&1 | tee -a deploy.log`
- **Writing `2>&1` after `tee`.** It then merges tee's streams, not the tool's.
  - Wrong: `deploy-tool "$site" | tee -a deploy.log 2>&1`
  - Right: `deploy-tool "$site" 2>&1 | tee -a deploy.log`
- **Trusting the exit status without pipefail.** A failed deploy looks successful.
  - Wrong: `deploy-tool ... | tee -a log` without `set -o pipefail` exits 0 on failure
  - Right: enable pipefail (or inspect `PIPESTATUS`)
