# Common Mistakes

- **Forgetting `-o /dev/null`.** The whole page is printed in front of the code and your output is garbage.
  - Right: `curl -s -o /dev/null -w '%{http_code}' "$url"`
- **Not handling the dead host.** A failed connection exits non-zero; with `set -e` the script dies on the first unreachable URL and the rest is never checked.
  - Right: `code=$(curl ...) || true`, then treat `000` as a problem.
- **Comparing codes as numbers when they are `000`.** `[[ $code -ge 400 ]]` is false for 000, so unreachable hosts look fine.
  - Right: test `000` explicitly, for example `case $code in 000|[45]??) ...`.
- **Counting redirects as errors.** 301 and 302 mean "moved", not "broken". Only 4xx and 5xx (and 000) are problems in this task.
- **Putting `%{http_code}` in double quotes.** The shell tries to expand `%{...}`-looking text in odd cases; single quotes keep it literal for curl.
