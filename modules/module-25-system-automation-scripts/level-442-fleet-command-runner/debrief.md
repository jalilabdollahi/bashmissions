# Debrief: Fleet Command Runner

## What you learned

Running a command on many machines is mostly an exercise in handling partial failure. Some hosts will be down, some will lack the command, and your script has to report each honestly and finish the rest. The summary and the exit status turn a pile of output into something a cron job or a human can act on.

## Under the hood

ssh forwards your terminal's standard input to the remote command. Inside `while read ... < file` that input is your host list, so ssh eats it and the loop ends early. This is one of the most famous shell bugs; `-n` is the cure. `BatchMode=yes` makes ssh fail instead of prompting when it cannot authenticate with a key, which is what you want from anything that runs without a person watching.

The 255 convention comes from ssh itself: it reserves that status for its own errors, so you can tell "the connection broke" from "the command said no".

## In real work

Add `-o ConnectTimeout=5` so a black-holed host costs seconds, not minutes, and send the results to a file per run. When the fleet grows beyond a few dozen, move to a tool that runs in parallel with limits.

## Going further

Reading is the safe half. Next you will push a file to every host, with a dry-run mode that shows what would happen first.
