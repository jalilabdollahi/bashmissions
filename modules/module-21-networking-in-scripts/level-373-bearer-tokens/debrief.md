# Debrief: Bearer Tokens

## What you learned

A **bearer token** is a password the server hands out once; whoever "bears" it is let in. That is exactly why it must be guarded: anyone who sees the token can act as you. Scripts follow three habits: read the token from the environment (or a locked-down file), use it in one place only, and never print it, trace it or store it.

## Under the hood

The header `Authorization: Bearer <token>` rides along with the request. The server checks it and answers 401 (not authenticated) or 403 (authenticated, but not allowed) when it does not like what it sees. Your script turned those into clear messages instead of dumping an error page.

Leaks are usually accidental. `set -x` echoes every expanded command, `curl -v` prints request headers, `echo "using $LF_TOKEN"` is a debugging line someone forgets to remove, and a token typed on the command line is visible to other users in the process list. Environment variables do not appear in the process list on most systems, which is another reason to prefer them. The stub in this level logs the header with the token masked, a habit worth copying in your own logs.

## In real work

CI systems, cron jobs and deploy scripts all receive their tokens through environment variables or a secrets manager. A script that hard-codes one will sooner or later end up in a repository.

## Going further

You branched on 200 and 401 by hand. The next level shows curl doing the bad-status check for you with `--fail`.
