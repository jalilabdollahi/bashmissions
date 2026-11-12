# Walkthrough: Layered Defaults

## The plan

Every setting has up to three possible sources. Instead of an `if` ladder per
setting, apply the layers in order from weakest to strongest and let each one
overwrite the variable only when it has something to say. When the last layer is
done, the variable holds the winner.

## Building it

Layer one is plain assignments, the values we ship:

```bash
host=localhost
port=25
tls=off
```

Layer two is the file. It is optional, so test before reading:
`[[ -n ${1:-} && -r ${1:-} ]]`. Read it with `IFS='=' read -r key value`. With a
single non-blank separator, `read` splits at the first `=` and hands the whole
remainder to the last variable, so `a=b=c` gives key `a` and value `b=c`. Trim
both pieces, skip an empty value, then pick the setting with `case`:

```bash
case $key in
  RELAY_HOST) host=$value ;;
  RELAY_PORT) port=$value ;;
  RELAY_TLS)  tls=$value ;;
esac
```

A comment such as `# RELAY_TLS` becomes key `# RELAY_TLS`, which matches nothing,
so it is ignored without any extra code. Unknown names behave the same way.

Layer three is the environment. `${RELAY_HOST:-$host}` means "the variable if it
has text, otherwise what we already decided", which is exactly "highest layer
wins, empty counts as absent":

```bash
host=${RELAY_HOST:-$host}
```

## Complete solution

answer.sh holds the full script: defaults, the file loop, three `:-` lines, three
`echo`s.

## Trying it by hand

```
printf 'RELAY_PORT=587\n' > relay.conf
./solution.sh relay.conf          # port=587
RELAY_PORT=2525 ./solution.sh relay.conf   # port=2525
```

## Alternative

You can compute each setting in one expression, `port=${RELAY_PORT:-${file_port:-25}}`,
after the file loop stored its values in `file_*` variables. It reads well for
three settings, but the overwrite style scales better when the list grows.
