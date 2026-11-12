# Debrief: Exported to Children

## What you learned
Variables live inside the process that created them. A program started by your script is a new process and sees only the **exported** variables. Exporting is how you deliberately pass settings down.

## Under the hood
When Bash starts a command it builds an environment: a list of `NAME=value` strings, taken from the exported variables. The child gets a *copy*. If the child changes its copy, the parent never notices, and if the parent changes the variable later the child, already running, does not either. Data only flows downwards, once, at start-up.

That also explains why `$USER` and `$HOME` were already available in your very first scripts: your terminal exported them, and Bash inherited them. And it is why private values - passwords, scratch paths - should stay unexported unless a child truly needs them.

## In real work
`export` is how you configure the tools you call: `export LC_ALL=C` before `sort`, `export AWS_REGION=...` before a deploy tool. Anything that appears in `env` output was exported by somebody.

## Going further
The reverse of this level is the next one: a script that reads its configuration from the environment, with fallbacks.
