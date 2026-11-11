# Walkthrough: PID File Health

## The plan
A PID file is a note a daemon leaves: "I am process 4242". Notes go out of date
when the daemon crashes or the machine reboots. A checker has to ask the
system whether the note is still true, and "is some process 4242 alive?" is not
enough, because the kernel reuses numbers. So the script asks two things:
*is it alive* and *is it the right program*.

## Step by step
1. Handle the cases that need no system call: wrong arguments (exit 2),
   missing file (`stopped`, exit 3).

2. Read the number and make sure it really is one. `$(< file)` is Bash's
   shortcut for reading a file without starting `cat`:

   ```bash
   pid=$(< "$pidfile")
   [[ $pid =~ ^[0-9]+$ ]] || { echo "bad pid file"; exit 2; }
   ```

   This check also stops a file containing `; rm -rf /` from ever reaching
   another command.

3. Ask `ps` for the name. A dead process makes `ps` exit with an error, which
   `set -e` would treat as fatal, so absorb it with `|| true` and look at the
   output instead:

   ```bash
   actual=$(ps -p "$pid" -o comm= || true)
   ```

4. Decide. Empty output means nothing is running with that number. A
   different name means the number was recycled. In both cases remove the
   PID file with `rm -f`, report, and exit 1. Otherwise print `running`.

## Try it by hand
`ps` here is a stub where you choose the running processes:
```
mkdir -p run; echo 4242 > run/nginx.pid
FAKE_PS="1:init 4242:nginx" ./solution.sh run/nginx.pid nginx
FAKE_PS="1:init 4242:cron"  ./solution.sh run/nginx.pid nginx
ls run
```

## Alternative
`kill -0 "$pid"` tests whether you may signal a process without sending
anything. It is the usual one-liner for "alive?", but it cannot tell you
*which* program owns the number, and fails with a permission error for
processes of other users.
