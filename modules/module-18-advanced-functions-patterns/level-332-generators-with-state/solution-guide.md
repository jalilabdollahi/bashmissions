# Walkthrough: Generators with State

## The plan

A generator hands out one new value per call and remembers how far it got.
Bash functions have no private memory, so the memory is a global variable that
only the generator touches: here an associative array with one counter per series.

## Step by step

The counters, starting from zero (nothing issued yet):

```bash
declare -A counters=([invoice]=0 [ticket]=0)
```

One small helper rejects unknown kinds. A kind is known when it is a key of the
array, which `${counters[$1]+x}` tests:

```bash
kind_ok() {
  if [[ -z ${counters[$1]+x} ]]; then
    echo "gen_next: unknown kind '$1'" >&2
    exit 2
  fi
}
```

`gen_next` increments, then formats into `REPLY`:

```bash
gen_next() {
  local kind=$1
  kind_ok "$kind"
  counters[$kind]=$(( counters[$kind] + 1 ))
  case $kind in
    invoice) printf -v REPLY 'INV-%04d' "${counters[invoice]}" ;;
    ticket)  printf -v REPLY 'TCK-%03d' "${counters[ticket]}" ;;
  esac
}
```

`printf -v NAME` writes into the variable instead of stdout, and `REPLY` is
the conventional name for "the result of the last helper".

The reading loop splits each line into a word and the rest. `reset` zeroes a
counter; anything else is a series name:

```bash
while read -r word arg; do
  [[ -z $word ]] && continue
  if [[ $word == reset ]]; then
    kind_ok "$arg"; counters[$arg]=0
  else
    gen_next "$word"; echo "$REPLY"
  fi
done
```

## The trap

Writing `id=$(gen_next invoice)` looks natural, but a command substitution
runs in a subshell: the increment happens in a copy of the shell and is gone
when it returns, so every invoice would be INV-0001. The validator rejects
that spelling on purpose.

## Try it by hand

```
printf 'invoice\nticket\ninvoice\nreset invoice\ninvoice\n' | ./solution.sh
```

## Alternative

Keep the counter in a file, read-increment-write each time. It survives between
runs, which is the point of Gus's old way, but two scripts racing on the file
are how the duplicate invoices happened.
