# Walkthrough: Regex in a Variable

## The problem
On the right-hand side of `=~`, Bash looks at quoting before it hands the text
to the regex engine:

| written as | meaning |
|---|---|
| `[[ $s =~ $re ]]` | `$re` is a **regex** |
| `[[ $s =~ "$re" ]]` | `$re` is **literal text** (every character escaped) |
| `[[ $s =~ ^a+$ ]]` | a regex written inline |

So `[[ 4410 =~ "^[0-9]+$" ]]` asks "does the line contain the characters
`^[0-9]+$`?" and, of course, nothing does. Ollie's regex mode quoted the
pattern, which broke it; his literal mode left it unquoted, so `10.0.0.1`
matched `10x0y0z1`, because the dots were wildcards.

## The fix
Swap the quoting:

```bash
if [[ $mode == regex ]]; then
  [[ $line =~ $pattern ]]        # regex
else
  [[ $line =~ "$pattern" ]]      # literal
fi
```

## The validation
Anything other than `regex` or `literal`, or the wrong number of arguments, goes
to the `usage` function, which writes to stderr and exits with 2.

## Complete solution
See `answer.sh`.

## Try it by hand
```bash
printf 'v1.2.3\nv1x2x3\n' | ./solution.sh regex  'v1.2.3'
printf 'v1.2.3\nv1x2x3\n' | ./solution.sh literal 'v1.2.3'
```
The first prints both lines, the second only the first.

## Alternative
Put regexes with spaces or `|` into a variable *even when they are fixed*:
`re='ERROR|FATAL'`. Inline, an unquoted `|` or `)` is a Bash syntax error, and
quoting would make it literal; the variable avoids both problems.
