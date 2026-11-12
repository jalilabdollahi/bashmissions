# Debrief: Empty or Not

Empty is not the same as missing, and neither is the same as zero. Forms,
config files and environment variables hand your script blank values all the
time, and the first line of defence is `-z` (zero length) and `-n` (non-zero
length).

## Under the hood

Both are unary tests: they take a single string and test its length. `-z`
is true when the length is 0, `-n` when it is more than 0. A variable holding a
single space has length 1, so it counts as non-empty; if you need to ignore
whitespace you must trim it first.

Under `set -u`, reading an unset variable is a fatal error. The `${var:-}` form
substitutes an empty string when the variable is unset or empty, so the test
afterwards can do its job. You met that expansion in Module 2, and it pairs
naturally with `-z`.

## Where it shows up

Validating user input, checking that an environment variable such as a token or
a hostname was really provided, and skipping optional sections of a report.

## Going further

Next up are numbers. `==` compares text, but "9" and "10" are very different
questions when you ask which is bigger.
