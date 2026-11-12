# Walkthrough: A FIFO Semaphore

## The plan

A *semaphore* is a counter that jobs must "take from" before they run. A
named pipe makes a handy counter, because the kernel already provides what we
need: data waits in the pipe, and `read` blocks while it is empty. One token in
the pipe = one free seat.

## Step by step

Create the pipe and open it on descriptor 3 for **both** reading and writing.
Opening a FIFO for only reading would block until a writer appeared; `<>` avoids
that. After the open the file name is no longer needed, so we remove it, and the
pipe lives on as long as descriptor 3 is open:

```bash
mkfifo slots.fifo
exec 3<> slots.fifo
rm slots.fifo
```

Fill it with SLOTS tokens. A token is just one newline:

```bash
for ((i = 0; i < slots; i++)); do
  echo >&3
done
```

Now every job goes through the bouncer. `read -r -u 3` removes one line from the
pipe, and if the pipe is empty it waits. The job itself runs as a background group
which hands the token back when it is done, **whether render succeeded or not**:

```bash
for name in "$@"; do
  read -r -u 3
  {
    if ! render "$name"; then echo "$name" >> failed.log; fi
    echo >&3
  } &
done
wait
```

If the group forgot to return the token on failure, every failed render would
shrink the pool by one, and with enough failures the loop would block forever.
Descriptor 3 is inherited by the background group, which is how the job can
write to it.

The failures cannot be counted in a variable (the groups run in child
processes), so they leave a line in `failed.log`, and the script counts lines
afterwards.

## The complete solution

```bash
#!/usr/bin/env bash
set -euo pipefail

if [[ $# -lt 1 ]]; then
  echo "usage: solution.sh SLOTS NAME..." >&2
  exit 2
fi
slots=$1
shift

mkfifo slots.fifo
exec 3<> slots.fifo
rm slots.fifo

for ((i = 0; i < slots; i++)); do
  echo >&3
done

: > failed.log

for name in "$@"; do
  read -r -u 3
  {
    if ! render "$name"; then
      echo "$name" >> failed.log
    fi
    echo >&3
  } &
done
wait

failed=$(( $(wc -l < failed.log) ))
echo "rendered $#, failed $failed"
if (( failed > 0 )); then
  exit 1
fi
```

## Try it by hand

```bash
./solution.sh 2 a b c-bad d e; echo "exit $?"
cat failed.log
```

## An alternative

Level 310's `wait -n` pool keeps the count in a variable and needs no file
descriptors. The FIFO semaphore is the choice when the jobs are started by
*different* processes that must share one limit, because the pipe can be shared
and a variable cannot.
