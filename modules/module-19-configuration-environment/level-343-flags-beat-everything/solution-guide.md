# Walkthrough: Flags Beat Everything

## The plan

Four layers feed each setting: flags, environment, file, defaults. The trap is
ordering. The `--config` flag decides which file to read, so the command line has
to be parsed first, but flags must also rank above the file. The way out is to
separate gathering from deciding: collect every layer into its own place, then run
one small decision loop.

## Building it

Keep the layers in associative arrays, which store values under names:

```bash
declare -A flag file default
default=([retention]=7 [dest]=/var/backups [compress]=no)
```

Parse the arguments with `while (( $# ))` and `case`. Options with a value come
in two spellings, so there are two patterns: `--dest|--retention|--config` takes
`$2` and shifts twice, while `--dest=*` cuts the value out of `$1` with `${1#*=}`
and shifts once. Check `(( $# < 2 ))` before touching `$2`, or `set -u` kills the
script with an unhelpful message instead of yours. Anything else beginning with
`-` is an unknown option; anything left is an unexpected argument.

Once the loop ends, `${flag[config]:-}` tells you whether a file was requested.
Read it like before, keeping only the three known names in the `file` array.

The decision loop goes strongest to weakest:

```bash
for name in retention dest compress; do
  envvar=TIDE_${name^^}
  if   [[ -n ${flag[$name]:-}  ]]; then value=${flag[$name]} source=flag
  elif [[ -n ${!envvar:-}      ]]; then value=${!envvar}     source=env
  ...
```

`${!envvar}` is indirect expansion: the value of the variable whose name is stored
in `envvar`.

## Complete solution

See answer.sh. Order of sections: flags, file, decision loop.

## Trying it by hand

```
TIDE_DEST=/mnt/x ./solution.sh --retention 3
```

## Alternative

`getopts` handles short options (`-r 3`) well, but it cannot parse `--long` options,
which is why a hand-written `case` loop is the usual tool in scripts that need them.
