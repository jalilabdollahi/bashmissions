# Walkthrough: Builder Pattern

## The plan

A builder constructs something step by step. Options arrive one at a time and
each is validated at once, so the error points at the field that is wrong.
Only when everything is in place does `build` check the relations between
fields and produce the result. Until then nothing is printed, so a failure
leaves no half-finished output.

## Step by step

The spec is one associative array; `vm_new` resets it to the defaults in one
assignment:

```bash
declare -A spec=()
vm_new() {
  spec=([name]=$1 [cpus]=1 [ram_gb]=2 [disk_gb]=20 [region]=eu-north)
}
```

Three of the four setters check a whole number in a range, so a tiny helper
avoids repeating it:

```bash
in_range() { [[ $1 =~ ^[0-9]+$ ]] && (( $1 >= $2 && $1 <= $3 )); }
```

The regex check comes first; the arithmetic comparison would choke on
`lots`. Each setter validates and stores, or complains in its own name and
returns 1:

```bash
with_cpus() {
  if ! in_range "$1" 1 16; then
    echo "with_cpus: invalid value '$1'" >&2
    return 1
  fi
  spec[cpus]=$1
}
```

`with_region` uses a `case` against the three allowed regions.

`build` is the only place that compares fields: RAM must be at least
2 GB per CPU. Then it prints the five lines in a fixed order.

Finally the loop splits each `key=value`, dispatches to the setter, and turns
any failure into exit 2: `with_cpus "$value" || exit 2`.

## Try it by hand

```
./solution.sh anchovy-01
./solution.sh barracuda-02 cpus=4 ram_gb=16 region=us-east
./solution.sh dory-03 cpus=8 ram_gb=8; echo "exit=$?"
```

## Alternative

A single `create_vm` function with positional parameters (`create_vm NAME
CPUS RAM DISK REGION`) is shorter, and perfect until options are optional,
which is exactly when people swap RAM and disk.
