# Walkthrough: Semver Bump

## The plan
Semantic versioning is a tiny grammar: `MAJOR.MINOR.PATCH`. Bumping means
parsing it into three integers, incrementing one, and zeroing everything
below it. The script has two jobs: be strict about what it accepts, and do
real arithmetic.

## Steps
Argument checks come first, and `case` is the natural tool for "one of these
words":

```bash
(( $# == 2 )) || { echo "$usage" >&2; exit 2; }
case $2 in major|minor|patch) ;; *) echo "$usage" >&2; exit 2 ;; esac
```

Next the version. A single regex checks the shape and captures the pieces. A
number is `0` or a digit 1-9 followed by more digits, so `01` and `1.2` and
`1.2.3-rc1` all fail to match:

```bash
num='(0|[1-9][0-9]*)'
re="^(v?)$num\\.$num\\.$num\$"
[[ $version =~ $re ]] || { echo "invalid version: $version" >&2; exit 2; }
```

The regex lives in a variable so no quoting rules fight with it. Captures are
in `BASH_REMATCH[1]` (the prefix) through `[4]`.

Then the bump itself, again with `case`. The order of the assignments inside
each branch matters little, but the resets are the whole point of the rules:

```bash
case $part in
  major) major=$(( major + 1 )); minor=0; patch=0 ;;
  minor) minor=$(( minor + 1 )); patch=0 ;;
  patch) patch=$(( patch + 1 )) ;;
esac
echo "$prefix$major.$minor.$patch"
```

Because the numbers are integers, `1.9.9` minor becomes `1.10.0`: there is no
digit-by-digit carry to get wrong.

## Try it by hand
```bash
./solution.sh 1.9.9 minor
./solution.sh v1.2.3-rc1 patch; echo "exit $?"
```

## Alternative
`IFS=. read -r a b c <<< "$version"` splits quickly but accepts `1.2`,
`1..3` and `a.b.c`. Validating with a regex first makes the strictness
explicit, and strictness is what you want in release tooling.
