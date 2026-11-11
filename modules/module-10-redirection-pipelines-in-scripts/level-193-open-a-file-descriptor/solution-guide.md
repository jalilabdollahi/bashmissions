# Walkthrough: Open a File Descriptor

## The plan

Open `report.txt` once as descriptor 3, write one line per service to it,
close it, and print the summary on the normal stdout.

## Step by step

Until now each redirection belonged to one command: `cmd > file`. The file is
opened before the command and closed after. That is fine for one write, but a
script that writes to the same report from many places would reopen (and with
`>`, truncate!) the file each time.

`exec` with only redirections changes the shell itself instead of running a
command. So:

```bash
exec 3> report.txt
```

opens report.txt once, keeps it open as number 3, and creates it empty. The
numbers 0, 1 and 2 are taken (stdin, stdout, stderr), so 3 is the first free
one. Then any command can aim at it:

```bash
echo "$service: $state" >&3
```

The `&` before the 3 means "descriptor", not "file called 3". Because every
line goes to the same open file, they land one after another.

For the service state, `state=$(svc-status "$service")` captures what the tool
prints; the exit status of the assignment is the exit status of the command
substitution, so `|| down=$(( down + 1 ))` counts only failures.

Finally, `exec 3>&-` closes the descriptor.

## The complete solution

See answer.sh.

## Trying it by hand

```bash
./solution.sh nginx bad-mailer postgres
cat report.txt
```

## An alternative

Redirect the whole loop once: `for ...; done > report.txt` (you will do that
with blocks in a later level). That is shorter, but then the loop's own stdout
is captured too. A private descriptor lets the report stay separate from
whatever else the loop prints.
