# Debrief: Anchored Replacements

Replacements have positions. `${v/old/new}` and `${v//old/new}` look anywhere, but
`${v/#old/new}` only looks at the start and `${v/%old/new}` only at the end. The
symbols are the same ones you used for trimming: `#` for the front, `%` for the
back. Anchoring is what makes a replacement *safe*: it says not just what to
change but where, so lookalike text elsewhere in the value is left alone.

Think of the tricky inputs from this level: a backup directory that contains the
legacy path in the middle, and a file called `audit.log.old` that contains `.log`
but does not end with it. A plain replace would have damaged both. Real
migrations, path rewrites and URL fixes are full of such lookalikes, which is why
careful scripts anchor.

Anchored replacement also reads as a small, complete idea: "if it starts with X,
make it Y". If it does not, you get the original back, so there is no error to
handle and no need for an `if` around it.

Going further: replacing text is one kind of change. The next level changes the
case of letters, which is another job that people used to hand to `tr`.
