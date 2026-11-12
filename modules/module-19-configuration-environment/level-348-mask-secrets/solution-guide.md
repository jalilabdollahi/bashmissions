# Walkthrough: Mask Secrets

## The plan

Output is a leak path just like the files are. Before printing a setting, decide
what it is. Names tell you most of the story (`..._PASSWORD`), but some secrets
hide inside harmless-looking values (a database URL with a password in it). Run
every setting through a small filter, and print the filtered value.

## Building it

Read the file with the familiar loop (`IFS='=' read -r name value`, trim both,
skip blanks and comments). Then branch on the name. Uppercasing a copy makes the
comparison case-insensitive without touching the name that gets printed, and a
`case` statement with glob patterns that start with `*` tests the ending:

```bash
case ${name^^} in
  *_KEY|*_TOKEN|*_SECRET|*_PASSWORD) ... ;;
```

`MONKEY` does not match `*_KEY` because the underscore is part of the pattern, so
look-alikes are safe.

Inside the secret branch, the length decides how much to reveal. Long secrets can
show their tail, short ones nothing at all (four characters of a six-character
password would give away two thirds of it):

```bash
if (( ${#value} >= 12 )); then value="****${value: -4}"
elif [[ -n $value ]]; then value="****"
fi
```

Note the space in `${value: -4}`; `${value:-4}` is the "default value" operator.

The other branch handles URLs. A regex with two groups captures everything up to
and including `user:` and everything from the `@` on, so the password between
them is simply not copied:

```bash
if [[ $value =~ ^(.*://[^:/@]*:)[^@/]*(@.*)$ ]]; then
  value="${BASH_REMATCH[1]}****${BASH_REMATCH[2]}"
fi
```

The password class `[^@/]*` stops at a slash, so `http://host:8080/x@y` (a port
and a path, no password) is left alone.

## Trying it by hand

```
printf 'DB_PASSWORD=hunter2\nAPI_TOKEN=sk_live_abcdef123456\n' > t.env
./solution.sh t.env
```

## Alternative

`sed -E 's#(://[^:/@]*:)[^@/]*@#\1****@#'` masks the URL part in one command, but
Bash's own regex avoids a process per line and keeps both branches in one place.
