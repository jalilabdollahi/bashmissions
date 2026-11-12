# Common Mistakes

- **Echoing the secret back.** `echo "You typed $password"` defeats the purpose.
  Right: `echo "password stored (${#password} characters)"`.
- **Using plain `read` for a password.** `read -r password` shows every
  character. Right: `read -rs password` (or `-rsp "prompt: "`).
- **Forgetting the newline afterwards.** After `read -s` the next output joins
  the prompt line. Add `echo >&2` right after it.
- **Taking the password as an argument.** `./reset.sh hunter2` puts it into
  `ps` output and shell history. Read it from the terminal instead.
