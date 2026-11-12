# Common Mistakes

- **Pointing both streams at the same name with two separate redirections.** The file is opened twice.
  - Wrong: `cert-check "$domain" > cert.log 2> cert.log` (lines overwrite each other)
  - Right: `cert-check "$domain" &> cert.log`
- **Putting a space inside the operator.** `& >` is something else entirely: it backgrounds the command.
  - Wrong: `cert-check "$domain" & > cert.log`
  - Right: `cert-check "$domain" &> cert.log`
- **Counting lines before the tool has finished.** In a script the call is synchronous, but with a trailing `&` it would not be.
  - Wrong: `cert-check "$domain" &> cert.log &` then `wc -l`
  - Right: run it in the foreground, then count
- **Using `&>` in a script run by `sh`.** It is a Bash feature.
  - Symptom: with `sh script.sh` the command runs in the background and the file is empty
  - Right: run with `bash`, keep the `#!/usr/bin/env bash` line
