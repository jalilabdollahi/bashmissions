# Debrief: Step Runner

The mental model: **a pipeline is a chain of promises, and a failure breaks the
chain.** Each step only makes sense if the steps before it succeeded, so the
runner's job is to refuse to continue and to say exactly where it stopped.

Under the hood, every process ends with a number between 0 and 255. Zero means
success. Your runner reads that number and passes it up unchanged, which is how
whatever called you (a cron entry, a CI server, another script) learns the
truth. If you flattened every failure to `exit 1` you would lose information
such as 127 meaning "command not found".

`set -e` is a safety net for the steps you did not expect to fail. For the
failure you do expect and want to describe, you handle it yourself with `||` or
`if`, which is why the runner uses both together.

In real work this is the skeleton of Makefile recipes, GitHub Actions `run:`
blocks (each runs with `-e`) and the shell scripts inside Jenkins stages. The
`step N/TOTAL` banner is exactly the line you scroll back to when a build goes
red.

Going further: stopping at the first failure is right for a build, but not for
linting, where developers want to see every problem in one run. The next level
keeps going and collects the failures instead.
