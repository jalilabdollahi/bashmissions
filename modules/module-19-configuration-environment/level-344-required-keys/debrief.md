# Debrief: Required Keys

The mental model: **validate early, validate completely.** A script that is going
to fail because of its configuration should fail before it does any work, and it
should say everything that is wrong in one go. Every extra run an engineer needs
to discover the next problem costs minutes, and in a deploy pipeline it costs a
queue slot too.

Two ideas make this pattern work. First, treat "absent" and "empty" as the same
thing unless you have a reason not to; `${array[$key]:-}` does that in one test,
because an unset element and an empty one both expand to nothing. Second, count
failures instead of exiting on them. The loop reports, the counter remembers, and
a single `exit 1` after the loop turns many small complaints into one verdict.

Mind the trap with `set -e`: `(( n++ ))` returns status 1 when `n` was 0, which
kills the script on the very first miss. Assigning with `n=$(( n + 1 ))` always
succeeds.

Real tools do the same: `terraform validate`, linters and `docker compose config`
all print every error they find. The summary line ("3 of 4 missing") is also a
gift to whoever reads the CI log.

Going further: presence is only the first test. A key may exist and still be
nonsense (`PORT=banana`); a later level checks types. First, though, there is a
bigger question: where does the config file even live? That is the next level.
