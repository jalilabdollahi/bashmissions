# Walkthrough: Deploy with a Health Gate

## The plan
"Deployed" and "working" are different facts. A health gate closes the gap: after
the deploy, keep asking the service whether it is healthy, wait between asks,
and stop after a limit. Success exits 0 quickly; failure exits non-zero, which
is what lets the pipeline roll back (the next level).

## Steps
Validate the optional attempt count with a regex (digits only), then check it is
at least 1. Re-reading it as base ten with `10#` keeps a value like `08` from
being taken for octal:

```bash
max=${3:-5}
[[ $max =~ ^[0-9]+$ ]] && (( 10#$max >= 1 )) || { usage...; exit 2; }
```

Deploy first, and stop if the deploy itself failed. There is nothing to poll:

```bash
if ! deployctl push "$version"; then echo "deploy failed" >&2; exit 1; fi
```

The poll is a counted loop. The condition is the curl command itself.
`-f` makes an HTTP error status a failure exit code, `-s` silences the progress
meter, and `--max-time 2` bounds each request so a hung service cannot freeze the
gate. The output is thrown away because only the exit status matters:

```bash
for (( attempt = 1; attempt <= max; attempt++ )); do
  if curl -fs --max-time 2 "$url" >/dev/null 2>&1; then
    echo "healthy after $attempt attempt(s)"; exit 0
  fi
  echo "attempt $attempt/$max: not healthy"
  (( attempt < max )) && sleep 2
done
```

The `attempt < max` test avoids sleeping after the last failure, when nothing
remains to wait for. Falling out of the loop means the limit was reached:

```bash
echo "gave up after $max attempts" >&2
exit 1
```

## Try it by hand
```bash
FAKE_HEALTHY_AFTER=3 ./solution.sh 1.0.0 http://x/health
cat .calls.log      # sleeps are recorded, not performed
```

## Alternative
A `while ! curl ...; do sleep 2; done` loop is shorter, but has no limit, so a
broken release makes the pipeline hang until someone notices. The counter is the
safety.
