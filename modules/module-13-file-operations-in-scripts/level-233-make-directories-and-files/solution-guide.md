# Walkthrough: Make Directories and Files

## The plan

The job has a fixed shape: a folder skeleton and a few empty files. Two
things make it tricky for a script that other people will run twice: the
parent `sites` folder may be missing, and the files may already hold data.

## Step by step

First the guard. Exactly one argument is required:

```bash
if [[ $# -ne 1 ]]; then
  echo "usage: solution.sh CUSTOMER" >&2
  exit 2
fi
site="sites/$1"
```

Plain `mkdir sites/acme/logs` fails when `sites/acme` does not exist and fails
again on the second run ("File exists"). `mkdir -p` fixes both: it creates
every missing parent and treats an existing folder as success.

```bash
mkdir -p "$site/public" "$site/logs" "$site/backup"
```

The quotes matter because customers such as "Gull & Anchor Pub" have spaces.

For the files use `touch`. It creates a file that does not exist; if it does
exist, it only updates the modification time and leaves the content alone, so
a second run cannot erase a log.

```bash
touch "$site/logs/access.log" "$site/logs/error.log" "$site/public/index.html"
```

## The complete solution

```bash
#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 1 ]]; then
  echo "usage: solution.sh CUSTOMER" >&2
  exit 2
fi
site="sites/$1"
mkdir -p "$site/public" "$site/logs" "$site/backup"
touch "$site/logs/access.log" "$site/logs/error.log" "$site/public/index.html"
echo "ready: $site"
```

## Try it by hand

```bash
./solution.sh harbour-bakery
echo "hello" > sites/harbour-bakery/public/index.html
./solution.sh harbour-bakery
cat sites/harbour-bakery/public/index.html     # still says hello
```

## An alternative

You could write `[[ -d $site ]] || mkdir ...` checks around everything, but
that is three extra lines per folder to do what `-p` already does, and it
has a gap between the check and the action. Reach for the option made for
the job.

## Reading the result

After a run, `ls -R sites/harbour-bakery` shows the whole skeleton at once,
and `ls -l` on the logs shows they are empty (size 0). Run the script a
second time and compare: nothing changes except the modification times of
the files `touch` visited. That "second run changes nothing" property is
called idempotence, and it is the quality bar for every setup script.
