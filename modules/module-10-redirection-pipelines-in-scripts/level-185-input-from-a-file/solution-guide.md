# Walkthrough: Input from a File

## The plan

Validate the file, then run the mailer with the file wired to its stdin.

## Step by step

`lantern-mail` is a "filter-style" tool: it has no `--file` option and just
reads standard input. At a terminal you would type the body and finish with
Ctrl-D. In a script, standard input is whatever you point it at.

First the guard. `[[ -r $file ]]` is true when the file exists and you can
read it; we want the opposite, so negate it:

```bash
if [[ ! -r $file ]]; then
  echo "message file not found: $file" >&2
  exit 1
fi
```

`>&2` sends the message to standard error, the right place for complaints.

Then the redirection. `<` is the mirror of `>`: it opens the file for reading
and attaches it to descriptor 0:

```bash
lantern-mail "$recipient" < "$file"
```

The mailer reads until end of file and then prints its summary.

## The complete solution

```bash
#!/usr/bin/env bash
recipient=$1
file=$2
if [[ ! -r $file ]]; then
  echo "message file not found: $file" >&2
  exit 1
fi
lantern-mail "$recipient" < "$file"
```

## Trying it by hand

```bash
printf 'Hello\nWorld\n' > note.txt
./solution.sh me@example.test note.txt
./solution.sh me@example.test nothing.txt
```

## An alternative

`cat "$file" | lantern-mail "$recipient"` gives the same result but starts an
extra process, and hides an error if the file is missing inside the pipe. With
`<`, a missing file stops the command before it even starts.
