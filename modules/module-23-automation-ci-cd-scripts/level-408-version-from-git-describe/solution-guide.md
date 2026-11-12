# Walkthrough: Version from git describe

## The plan
A version stored in a file goes stale. A version computed from git cannot:
`git describe` reports the nearest tag, how many commits you are past it, and
the hash of where you are. Your script turns that sentence into a version.

## Steps
`--tags` lets describe use any tag, `--long` forces the full
`tag-N-ghash` shape even when you are exactly on a tag (so the parser sees one
format, not two), `--dirty` appends `-dirty` for uncommitted changes, and
`--match 'v[0-9]*'` ignores tags that are not releases.

If there is no matching tag, describe exits 128. Capture and branch together:

```bash
if out=$(git describe --tags --long --dirty --match 'v[0-9]*' 2>/dev/null); then
  :
else
  echo "version=0.0.0-dev+g$(git rev-parse --short HEAD)"; exit 0
fi
```

Parsing is where people go wrong. Splitting on `-` breaks for the tag
`v1.5.0-rc1`. Instead anchor on the shape of the *end*, which is fixed:

```bash
re='^v(.+)-([0-9]+)-g([0-9a-f]+)(-dirty)?$'
```

The greedy `(.+)` takes as much as it can, then backs off just enough for
`-N-g<hash>` to match, so the whole `1.5.0-rc1` lands in group 1. A final check
that the tag starts like `1.2.3` turns a tag such as `v2next` into the
`cannot parse` error instead of a nonsense version.

Last, the format. Zero commits and a clean tree means you really are on the
release, so print the tag. Otherwise print `-dev.N+ghash`, adding `.dirty` to
the build metadata when needed.

## Try it by hand
```bash
echo v1.4.0-12-g3f2a1bc > .describe
./solution.sh
rm .describe; echo cafe123 > .head; ./solution.sh
```

## Alternative
Without `--long`, describe prints just the tag on a tagged commit, which is
convenient to read but forces two parsing paths. One uniform format is easier
to get right.
