# Debrief: Fail on HTTP Errors

## What you learned

There are two layers of "it failed". The **transport** layer asks: did the request get there and back? The **HTTP** layer asks: what did the server say? Plain curl only reports the first. `--fail` folds the second into the first: status 400 or above becomes exit status 22, and the error page is thrown away instead of flowing into your data.

## Under the hood

curl exit statuses are a small vocabulary worth learning: 6 means the name did not resolve, 7 the connection was refused, 28 a timeout, 22 an HTTP error with `--fail`. A script can react differently to each: retry on 7 or 28, give up on 22.

Two shell details came together here. `|| rc=$?` is the standard way to capture a status under `set -e`, and `-sS` is the standard pair for scripts: silent progress, but errors still shown. Without `-S`, `-s` also hides error messages and you debug blind.

`--fail` is not perfect: some servers return 200 with an error inside the body, and a few return 4xx codes you want to read. `--fail-with-body` (newer curl) keeps the body when you need it. Neither replaces thinking about what a success looks like.

## In real work

Every unattended curl in a cron job or pipeline should either use `--fail` or check the code, otherwise a broken API silently corrupts the next step.

## Going further

Some failures are polite: "slow down, try again in 3 seconds". Next you will read the response headers and obey them.
