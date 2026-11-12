# Walkthrough: UPPER and lower

## The plan
Keep the argument, then print it twice: once converted to upper case, once to
lower case.

## The two operators
- `${var^^}` changes every letter to **upper** case. Two carets point "up".
- `${var,,}` changes every letter to **lower** case. Two commas hang "down".

Characters that have no case, such as digits and colons, are left alone, which is
exactly right for a MAC address.

```bash
mac=$1
echo "dhcp=${mac^^}"
echo "inventory=${mac,,}"
```

The variable `mac` is untouched; each expansion produces a converted copy, so
you can use both forms in the same script.

## Complete solution
```bash
#!/usr/bin/env bash
set -euo pipefail
mac=$1
echo "dhcp=${mac^^}"
echo "inventory=${mac,,}"
```

## Try it by hand
```bash
./solution.sh "aA:Bb:0c:1D:2e:3F"
./solution.sh ""
```

## Alternative
`echo "$mac" | tr 'a-z' 'A-Z'` is the traditional answer, and it works on very
old shells. In Bash 4 and later the expansion is simpler and avoids two process
launches. Note that both depend on the locale: in a non-English locale, accented
letters may or may not change. Network addresses are ASCII, so there is no issue.
