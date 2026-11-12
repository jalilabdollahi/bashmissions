# Debrief: Run All Linters

The mental model: **there are two kinds of failure policy, and a pipeline
author must choose on purpose.** Fail-fast is for steps that depend on each
other. Collect-all is for independent checks, where the fastest feedback loop
is seeing every problem in one run instead of fixing them one push at a time.

Mechanically, collect-all means separating *detecting* a failure from *acting*
on it. Inside the loop you only record (`rc`, an array entry). The decision to
exit non-zero happens once, after the loop. That separation is also how test
runners produce a summary and then a single exit code.

Note that the exit code is still honest: if any linter failed the script exits
1, so the pipeline step is red. Collecting results never means hiding them.

In real work you see this in pre-commit hooks, `make -k`, `go vet ./...` style
multi-checks and CI stages that upload every report before failing the job.

Going further: linters print human text, but test runners often speak a
machine format that a script can count and summarise. The next level parses
one of those, the TAP protocol.
