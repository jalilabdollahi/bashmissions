# Common Mistakes

- **Hard-coding the token "just to test".** It ends up in git history and chat logs. Always read `$LF_TOKEN`.
- **Debugging with `set -x` or `curl -v`.** Both print the Authorization header. Remove them before the script runs for real.
- **Single quotes around the header.** The shell does not expand the variable and the server receives the text `$LF_TOKEN`.
  - Wrong: `-H 'Authorization: Bearer $LF_TOKEN'`
  - Right: `-H "Authorization: Bearer $LF_TOKEN"`
- **Printing the token in an error message.** `echo "auth failed for token $LF_TOKEN"` leaks it into logs; say what happened, not what the secret was.
- **Using `$LF_TOKEN` unguarded under `set -u`.** The script dies with `unbound variable`. Check `${LF_TOKEN:-}` first and give a message people understand.
