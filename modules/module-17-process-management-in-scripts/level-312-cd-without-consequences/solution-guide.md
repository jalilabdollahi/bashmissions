# Walkthrough: cd Without Consequences

## The plan

`sitebuild` works on whatever folder it is started in, so for each site we have
to be in that site's folder. A plain `cd "$dir"` would move *our* script, and
every later relative path (`sites/shop`) would be resolved from the wrong place.
We could `cd ..` afterwards, but that breaks on nested paths and when the
`cd` fails halfway. A subshell makes the problem disappear.

## Step by step

Remember where we started, so we can prove at the end that we did not move:

```bash
start=$PWD
```

Each site gets a subshell. `cd` and `sitebuild` are joined with `&&`, so the
build only runs if the folder exists:

```bash
if ( cd "$dir" && sitebuild ); then
  echo "built $dir"
  built=$((built + 1))
else
  echo "failed $dir"
fi
```

Three things happen here. The `cd` changes the folder of the *subshell* only.
The exit status of `( ... )` is the status of its last command, so a missing
folder (cd fails) and a broken site (sitebuild fails) both land in the `else`
branch. And because the group is an `if` condition, `set -e` does not stop the
script on a failure; the loop simply continues with the next site.

The same relative paths now work for every site, because the main script is
always in the start folder.

After the loop, print the count (`$#` is the number of sites) and compare
`$PWD` with `$start`. Exit 1 when `built` is smaller than `$#`.

## The complete solution

```bash
#!/usr/bin/env bash
set -euo pipefail

if [[ $# -eq 0 ]]; then
  echo "usage: solution.sh SITE_DIR..." >&2
  exit 2
fi

start=$PWD
built=0

for dir in "$@"; do
  if ( cd "$dir" && sitebuild ); then
    echo "built $dir"
    built=$((built + 1))
  else
    echo "failed $dir"
  fi
done

echo "built $built of $# sites"
if [[ $PWD == "$start" ]]; then
  echo "still in the starting folder"
else
  echo "moved away from the starting folder"
fi

if (( built < $# )); then
  exit 1
fi
```

## Try it by hand

```bash
mkdir -p sites/blog && echo x > sites/blog/site.conf
./solution.sh sites/blog sites/nothing-here
cat sites/blog/build.log
```

## An alternative

`pushd "$dir"` and `popd` also go there and back, but they live in your main
shell, so a failure between them leaves you in the wrong folder. The subshell
cannot be left half-done.
