# Debrief: Talking to stderr

A well-behaved script keeps its answers and its complaints apart. This is a convention older than most of the tools you use.

## How it works
Every process starts with three numbered channels: 0 for input, 1 for normal output, 2 for errors. `>&2` means "point channel 1 at channel 2 for this command". The text still appears on your screen, because both go to the terminal, but a pipe or a redirect treats them separately: `script | grep x` only sees stdout, and cron mails both.

That is why error messages matter in the right place. If a warning goes to stdout, the next program in a pipeline reads it as data.

## In real work
Usage messages, warnings and failures belong on stderr. Results that other scripts may consume belong on stdout. Production scripts almost always keep this discipline.

## Going further
Next, a break from output: how to leave notes for humans inside the script itself.
