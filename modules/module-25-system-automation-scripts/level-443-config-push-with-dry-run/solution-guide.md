# Walkthrough: Config Push with Dry-Run

## The plan

A fleet push has three risks: pushing garbage, pushing to the wrong place, and
not knowing what happened. The script answers each: validate the payload,
offer a preview mode, and print one status line per host plus a summary.

## Building it

Parse `-n` first, then require exactly three positional arguments.

Validate before the loop. `[[ -r ]]` catches a typo in the path. `[[ -s ]]` is
true only for a file that exists and has at least one byte, which catches the
saved-too-early editor accident. Because these checks run before the loop,
nothing has been copied when they fail.

Inside the loop skip blanks and comments as before and count the hosts. The
dry-run branch only prints `would push FILE to HOST:PATH`. The real branch puts
`scp` straight into an `if`/`elif`: `scp -q -o BatchMode=yes "$file"
"$host:$path"`. A host that is down makes scp exit non-zero, the `else` prints
`FAILED`, and the loop continues. Quote `"$host:$remote_path"` as one word.

The summary depends on the mode. In a real run `pushed X of Y` and an exit
status of `(( pushed == total ))` tell cron whether the fleet is consistent.

## Complete solution

See answer.sh.

## Trying it by hand

```
printf 'anchovy\ndory\n' > web.txt; echo 'mode=prod' > app.conf
./solution.sh -n web.txt app.conf /srv/app.conf
./solution.sh web.txt app.conf /srv/app.conf; cat .calls.log
```

## Alternative

`rsync` is usually better than scp for configs (it skips unchanged files), but
the dry-run idea is identical: `rsync -n` previews the same way.
