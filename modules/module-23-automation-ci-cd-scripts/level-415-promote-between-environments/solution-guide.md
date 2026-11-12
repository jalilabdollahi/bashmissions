# Walkthrough: Promote Between Environments

## The plan
A promotion pipeline is a handful of rules in a fixed order, and a state change
at the very end. The state here is just files: `versions/ENV` records what each
environment runs. As long as you update those files only after a successful
deploy, the records and reality cannot drift apart.

## Steps
Keep the stages in an array. Their order *is* the pipeline, and a helper turns
a name into a position:

```bash
stages=(dev staging prod)
index_of() { local i; for i in "${!stages[@]}"; do
  [[ ${stages[i]} == "$1" ]] && { echo "$i"; return 0; }; done; return 1; }
```

With positions, the "one step at a time" rule is a single comparison:
`(( to_i == from_i + 1 ))`. That one expression also rejects skipping
(`dev prod`), going backwards and promoting to the same stage.

Read the versions. `$(<file)` reads a file without starting `cat`. Validate the
shape with a regex before trusting it.

The downgrade check needs a version comparison. `sort -V` is not available
everywhere, and comparing as text says `1.9.0` is newer than `1.10.0`. Split
on dots and compare part by part:

```bash
version_gt() {
  local a1 a2 a3 b1 b2 b3
  IFS=. read -r a1 a2 a3 <<< "$1"; IFS=. read -r b1 b2 b3 <<< "$2"
  (( a1 != b1 )) && { (( a1 > b1 )); return; }
  (( a2 != b2 )) && { (( a2 > b2 )); return; }
  (( a3 > b3 ))
}
```

Then the approval gate for prod (`[[ -f approvals/$version ]]`), the deploy
inside `if !`, and finally the record: write `versions/TO.tmp` and `mv` it into
place so the file is never half-written.

## Try it by hand
```bash
mkdir -p versions; echo 1.2.0 > versions/dev
./solution.sh dev staging; cat versions/staging .calls.log
```

## Alternative
Hard-coding `case "$from-$to" in dev-staging) ... ;; staging-prod) ... ;;`
works for three stages, but adding a fourth means editing every rule. Indexes
make the pipeline data.
