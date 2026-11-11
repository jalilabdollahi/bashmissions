# Walkthrough: Server Profile Card

## The plan
Resolve every input first, then print. That order matters: the required check runs before anything is printed, and the card is a plain template with no logic in it.

## Step by step
**Required input.** `SERVER` has no sensible default, so use the `:?` form. If it is missing, Bash prints the message and exits with status 1 before the card starts:

```bash
server=${SERVER:?SERVER must be set}
```

**A constant.** The company name should never change halfway through:

```bash
readonly COMPANY="Lanternfish Hosting"
```

**Defaults.** The `:-` form reads the setting or falls back:

```bash
role=${ROLE:-web}
ram=${RAM_GB:-8}
dimms=${DIMMS:-2}
```

**Integer arithmetic.** Declare once, then assign an expression. `10/4` is `2`, with no decimals:

```bash
declare -i per_dimm
per_dimm=$ram/$dimms
```

**Captured output.** `grep` finds the line `dory:Tidewater Books`, `cut` keeps the second colon-separated field. The `^$server:` pattern, with the colon, stops `dor` from matching `dory`. If nothing matches, `owner` is empty and a second fallback line fixes that:

```bash
owner=$(grep "^$server:" fixtures/owners.txt | cut -d: -f2)
owner=${owner:-unassigned}
```

**The card.** A here-document prints it; `${server}_${role}` needs braces:

```bash
cat <<EOF
=== $COMPANY ===
server: $server
...
slug:   ${server}_${role}
EOF
```

## Complete solution
The six pieces above, in the order shown, make up the whole script.

## Try it by hand
```
SERVER=dory ROLE=db RAM_GB=64 DIMMS=4 ./solution.sh
SERVER=kraken ./solution.sh
./solution.sh; echo "status: $?"
```

## Alternative
You could print each line with its own `echo`. The here-document is easier to compare with the card you want to see, and it does not need a new command on every line.
