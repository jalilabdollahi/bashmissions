# Debrief: Count and Invert

Two small switches change what grep *reports*. `-c` replaces the matching lines
with their **count**, and `-v` **inverts** the test so you get the lines that do
not match. Together with `-E` they cover most everyday log questions: "how many
errors?", "show me everything except the noise".

Inversion is a mindset shift. Often it is easier to describe what you do **not**
want (comments, blank lines, health-check requests) and keep the rest, than to
describe everything you do want. Reports built from `grep -v` are also resilient:
a new kind of interesting line shows up automatically, whereas an allow-list
would silently miss it.

Order matters when you combine rules, as the "commented-out failure" case shows.
A `# Failed password` line contains the phrase but is not an entry. Filter the
noise first, then count what is left. When a number looks wrong, ask which filter
ran before which.

And one more time, exit codes. `grep` is a *question-answering* tool: status 0
means "yes, I found something", 1 means "no". `-c` still answers with a number, but
the status follows the same rule, so `0` and a failing status arrive together.
In scripts with `set -e` or `pipefail`, handle that on purpose with `|| true`
or an `if`.

Going further: counting and selecting only read text. The next levels rewrite
it, starting with `sed s///`.
