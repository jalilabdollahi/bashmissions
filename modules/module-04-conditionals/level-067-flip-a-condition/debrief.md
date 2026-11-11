# Debrief: Flip a Condition

`!` means "not". It sits in front of a command or a test and turns success into
failure and failure into success. That small flip lets you write conditions the
way people say them: "if the backup directory does not exist, create it".

## Under the hood

Every command ends with an exit status, and `if` branches on whether it is zero.
`! cmd` runs the command and returns the opposite status. It works on any
command (`if ! grep -q ...`) and inside the double brackets too (`[[ ! -z $x ]]`,
though `-n` already says that). A space after `!` is required.

The grep flags here are worth keeping in your toolbox: an exact allowlist check
needs `-x` and `-F`, otherwise a short address matches inside a longer one, and
`.` quietly matches any character. These are the bugs that let the wrong
traffic through.

## Where it shows up

Guard clauses ("if the lock file is NOT gone, stop"), allowlists and blocklists,
"create it unless it exists", and checking that a required tool or setting is
missing before complaining.

## Going further

The next four levels ask questions about files: do they exist, can you read
them, are they empty, which one is newer? Many of those will want a `!` too.
