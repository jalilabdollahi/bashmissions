# Walkthrough: Idempotent Setup

## The plan
A script is idempotent when running it N times gives the same result as running
it once. The recipe is the same for every item: **describe the desired state,
check whether it already holds, act only if it does not, and say which happened.**

## Steps
Keep two counters and two tiny helpers so every block reports the same way:

```bash
created=0 present=0
created_it() { created=$(( created + 1 )); echo "created $1"; }
already_ok()  { present=$(( present + 1 )); echo "ok $1"; }
```

**The group.** `getent group deploy` exits 0 when the group exists and 2 when it
does not, so the command is the question: `if getent group deploy >/dev/null`.

**Directories.** `mkdir -p` is already idempotent, but you want to *know*
whether it did anything, hence the `-d` test first.

**The seed file.** Test with `-e` and write only when absent. The content
differing from your default is not a reason to touch it: the operator edited it.

**The profile line.** `grep -qxF -- "$line" "$profile"`: `-x` demands the whole
line, so `# umask 027` and `umask 0277` do not count; `-F` treats the text
literally; `-q` prints nothing and leaves only the status; `--` guards against
text starting with a dash. When appending, a file without a final newline would
glue your line onto its last one, so repair that first:

```bash
if [[ -s $profile && -n $(tail -c1 "$profile") ]]; then echo >> "$profile"; fi
```

**The link.** `-L` is true for any symlink, even a dangling one, which `-e`
would call missing. A regular file or folder with that name is a conflict, never
silently replaced.

## Try it by hand
```bash
./solution.sh; ./solution.sh      # the second run: everything "ok"
cat .calls.log                    # groupadd appears exactly once
```

## Alternative
Always running `mkdir -p`, `ln -sf` and `> file` also converges, but it
overwrites edits and cannot report what changed. Check-then-act is both safer
and more informative.
