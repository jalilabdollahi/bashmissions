# Common Mistakes

- **Forgetting `-s` in a script.** The progress meter lands on stderr and pollutes logs and cron mail.
  - Wrong: `text=$(curl "$url")`
  - Right: `text=$(curl -s "$url")`
- **Unquoted URLs.** A URL with `?` or `&` is mangled by the shell, and a variable inside it can split.
  - Wrong: `curl -s https://host/path?a=1&b=2`
  - Right: `curl -s "https://host/path?a=1&b=2"`
- **Letting `set -e` kill the script silently.** `text=$(curl -s "$url")` aborts with no message when the host is down.
  - Right: `if ! text=$(curl -s "$url"); then echo "..." >&2; exit 1; fi`
- **Treating empty output as success.** A page can be empty without any error; decide what that means with `${text:-no data}`.
- **Using `echo "$text"` for arbitrary content.** A body that starts with `-n` or contains backslashes is mangled by some echoes; `printf '%s\n' "$text"` is safe.
