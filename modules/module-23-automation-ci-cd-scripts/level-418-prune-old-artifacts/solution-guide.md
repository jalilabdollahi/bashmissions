# Walkthrough: Prune Old Artifacts

## The plan
"Keep the newest N" means ordering files by age. The folk answer is
`ls -t | tail ... | xargs rm`, and it fails because `ls` output is text that
has been flattened: a name with a space becomes two words, a name with a newline
becomes two lines, and a name that starts with `-` becomes an option. We avoid
text and keep names as array elements the whole way.

## Steps
Validate the inputs: KEEP must be digits only (so `-1` and `two` are rejected),
DIR must exist.

Collect the candidates with a glob. `"$dir"/*` yields one array element per
name, correct for any characters, and it does not match dotfiles. A test keeps
only plain files and ignores symlinks and folders:

```bash
shopt -s nullglob
files=()
for path in "$dir"/*; do
  [[ -f $path && ! -L $path ]] && files+=("$path")
done
```

(`nullglob` makes an empty directory produce an empty array rather than the
literal text `dir/*`.)

Now rank. Instead of sorting, count: for each file, how many others are newer?
`[[ a -nt b ]]` compares modification times portably. A tie needs a rule, so the
later name wins, which keeps results deterministic:

```bash
if [[ $other -nt $path ]]; then rank=$(( rank + 1 ))
elif [[ ! $path -nt $other && $other > $path ]]; then rank=$(( rank + 1 )); fi
```

The newest file has rank 0, the next rank 1, and so on, so `rank < keep`
selects exactly the KEEP newest. The loop is quadratic, which is irrelevant for
hundreds of files and is simple enough to trust.

Delete with `rm -f -- "$path"`; `--` ends option parsing so `-old.tar` is a file,
not a flag. Count both outcomes for the summary.

## Try it by hand
```bash
mkdir demo; touch -t 202401010000 demo/old.tar; touch demo/new.tar "demo/odd name.tar"
./solution.sh demo 2; ls demo
```

## Alternative
`find DIR -type f -newer MARKER` can pick files by age, but needs a marker
file, and sorting results requires `-printf` (GNU only). The `-nt` ranking
works unchanged on macOS and Linux.
