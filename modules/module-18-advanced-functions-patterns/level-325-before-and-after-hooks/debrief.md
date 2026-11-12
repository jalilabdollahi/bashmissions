# Debrief: Before and After Hooks

A hook is a promise: "at this moment I will call whatever you registered".
The caller stays small and stable; behaviour is added from outside. The
mental model is **two phases**. Registration builds a list of function names.
Execution walks the list. Keeping them separate is what lets you validate
everything up front.

## Under the hood

An array element is plain text, and `"$h" "$1"` makes Bash treat that text as
a command name with an argument. `"${before_hooks[@]}"` expands to one word per
element, so the order you appended is the order you call. An empty array
expands to nothing, so "no hooks" needs no special code (Bash 4.4 and later
handle this even with `set -u`).

## In real work

Git has hook scripts (`pre-commit`, `post-merge`), package managers have
pre-install and post-install steps, and `trap` is a one-slot hook for signals.
Deployment tools often run the "after" hooks in reverse order, so that cleanup
undoes setup like a stack: a handy variation when hooks acquire resources.

## Going further

Hooks that run the same pure computation again and again can be wasteful.
The next level makes a function remember its answers: memoization.
