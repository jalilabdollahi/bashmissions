# Common Mistakes

- **Ignoring end of input.** The loop never ends when the input is a closed pipe.
  Wrong: `while true; do read -r port; ...; done` with no check on read
  Right: `if ! read -r port; then exit 1; fi`
- **Comparing before checking digits.** Text in an arithmetic test is an error or silently zero.
  Wrong: `(( port >= 1 && port <= 65535 ))` first, with the input `eighty`
  Right: `[[ $port =~ ^[0-9]+$ ]] && (( ... ))`
- **Sending the prompt to stdout.** It pollutes the result.
  Wrong: `echo -n "port> "` (stdout)
  Right: `printf 'port> ' >&2`
- **Forgetting `break` after success.** The loop asks again and again.
- **Letting `0` pass.** A port range starts at 1; check both ends.
