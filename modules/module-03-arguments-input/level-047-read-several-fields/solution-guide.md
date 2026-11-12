# Walkthrough: Read Several Fields

## The plan
Instead of reading one string and cutting it apart afterwards, let `read` do the
cutting: it splits the line into fields on whitespace and assigns them to the
variable names you list.

## Building it
Read into three names, still with `-r`:

```bash
read -r host address role
```

For the input `barracuda 10.0.0.9 web frontend`, this produces:

| variable | value |
|---|---|
| host | barracuda |
| address | 10.0.0.9 |
| role | web frontend |

The rule: each variable except the last gets exactly one word, and the last one
gets everything that remains, with its inner spacing intact. Long runs of
spaces between fields are treated as one separator. If the line is too short,
the remaining variables are set to the empty string, so the "role missing" case
works without any extra code.

Then print in the order the objective wants:

```bash
echo "role=$role host=$host address=$address"
```

## Complete solution
```bash
#!/usr/bin/env bash
set -euo pipefail
read -r host address role
echo "role=$role host=$host address=$address"
```

## Try it by hand
```bash
echo "barracuda 10.0.0.9 web frontend" | ./solution.sh
echo "dory 10.0.2.2" | ./solution.sh
```

## Alternative
`awk '{print $1}'` style tools can pull fields too, but you would need three
separate calls (or one with a long print) and a way to capture the output. Letting
`read` do the split keeps everything in one command.
