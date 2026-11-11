# Common Mistakes

- **Writing the prompt with echo to stdout.** `echo "Server: "; read -r s` puts
  the question into pipelines. Right: `read -rp "Server: " s`.
- **Putting the prompt before the flag bundle.** `read "Server: " -rp s` fails;
  the string belongs right after `-p`: `read -rp "Server: " s`.
- **Forgetting the trailing space in the prompt.** `"Server:"` leaves the
  cursor touching the colon and the answer looks glued on.
- **Testing the prompt through a pipe and assuming it is broken.** With
  `echo x | ./solution.sh` Bash prints no prompt at all, by design. Run the
  script at a terminal to see it.
