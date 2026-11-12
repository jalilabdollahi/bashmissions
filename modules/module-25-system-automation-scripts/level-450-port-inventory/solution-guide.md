# Walkthrough: Port Inventory

## The plan

An inventory with no baseline is only a list. Comparing the open ports with
an expected table turns it into an audit: what is exposed that should not be,
and what should be answering but is silent.

## Building it

Start by reading the EXPECTED file into an associative array keyed by host:
`expected[$host]=" $ports "`. The extra spaces on both ends are a small trick:
they let a later test `[[ $want == *" $port "* ]]` match whole port numbers
only, so `80` can never match inside `8080`.

For the lookup, `${expected[$host]:-...}` takes the host's own line if there is
one and otherwise falls back to the `default` entry, and finally to a single
space, meaning nothing is expected. Using the default inside the expansion
avoids an `if` ladder.

Probing is `nc -z -w 1 "$host" "$port"`. `-z` connects and immediately closes
without sending data, `-w 1` gives up after a second, and the exit status is
the answer, so the call itself is the `if` condition. Hide stderr so a host
that does not resolve simply counts as "closed".

Inside the port loop build two things: a comma-joined list of open ports
(`open_list+=${open_list:+,}$port` adds a comma only when the list is not
empty) and an array of deviation notes. After the loop print the host line and
the notes, using `${open_list:--}` to show a dash for an empty list.

The exit status is `(( deviations == 0 ))`.

## Complete solution

See answer.sh.

## Trying it by hand

```
printf 'anchovy\n' > h.txt; printf 'default 22\n' > e.txt
./solution.sh h.txt e.txt
```

## Alternative

`nmap` does this far better on a real network. A plain `nc` loop is what you
have on a minimal server, and it is enough for a short list of ports.
