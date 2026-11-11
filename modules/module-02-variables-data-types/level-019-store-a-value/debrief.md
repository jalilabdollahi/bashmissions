# Debrief: Store a Value

## What you learned
A variable is a name attached to a piece of text. `name=value` stores it; `$name` reads it. Bash does not care about types here: everything you store is text, even a number like `07`.

## Under the hood
When Bash reads `echo "server: $server"`, it replaces `$server` with the stored text *before* it runs `echo`. The `echo` command never sees the dollar sign, only the finished sentence. That is also why `server = anchovy` fails: with spaces, the shell sees a command called `server` with two arguments.

The `RACK` you read was an environment variable, set by whoever launched your script. `$USER` and `$HOME` in module 1 were the same kind of thing. Copying it with `rack=$RACK` gives your script its own name for it.

## In real work
Every serious script starts by naming its important values once at the top: paths, hostnames, limits. When one of them changes, you edit one line.

## Going further
You printed `$server` on its own line. What if you want `anchovy_backup` right next to the name? The next level shows why that needs braces.
