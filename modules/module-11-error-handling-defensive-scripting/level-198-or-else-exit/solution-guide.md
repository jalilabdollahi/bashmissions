# Walkthrough: Or Else Exit

## The plan
The delete is only safe if we are really inside the release folder. So the `cd`
gets a safety net: if it fails, print a message and leave before the next line
gets a chance to run.

## Why the starter is dangerous
When `cd` fails, bash prints its complaint and goes on to the next line. The
working directory has not changed, so `rm -f -- ./*.old` happily deletes the
`.old` files of the folder you started in. The test "missing folder must not touch
the current folder" plants two such files and checks they survive.

## Building the guard
`A || B` means "run B only if A failed". We need two things in B, a message and
an exit, so we group them with braces:

```bash
cd "$1" 2>/dev/null || { echo "deploy: cannot enter $1" >&2; exit 1; }
```

`2>/dev/null` silences the message `cd` prints itself, so you see
one clear line instead of two.

Three small details: the space after `{` is required, the last command inside
needs a `;` (or a newline) before `}`, and `>&2` puts the message on stderr
where error messages belong.

## Complete solution
```bash
#!/usr/bin/env bash
cd "$1" 2>/dev/null || { echo "deploy: cannot enter $1" >&2; exit 1; }
rm -f -- ./*.old
echo "cleaned $1"
```

## Try it by hand
```bash
mkdir -p releases/v12 && touch releases/v12/a.old keep.old
./solution.sh releases/v12      # cleaned releases/v12
./solution.sh nowhere           # deploy: cannot enter nowhere
echo $?                         # 1
ls keep.old                     # still there
```

## Alternative
An `if ! cd "$1"; then ...; exit 1; fi` block does the same and reads well when
the recovery takes many lines. For a single message and an exit, `|| { ...; }`
keeps the guard glued to the command it protects, which is the point.
