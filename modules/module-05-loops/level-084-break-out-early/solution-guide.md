# Walkthrough: Break Out Early

## The plan
Walk the servers in order. Before patching each one, look for its marker file. A marker means "stop everything", so you report and leave the loop. Without a marker, patch and move on.

## Step by step
1. Write the list loop: `for server in anchovy barracuda cuttlefish dory eel flounder; do`.
2. At the top of the body test for the marker: `if [[ -e down/$server ]]; then`. The `-e` test is true if the path exists, whatever it is.
3. Inside the `if`, print `STOP: $server is down`, then `break`. Control jumps to the first line after `done`.
4. After the `if` block, print `patched $server`. Because `break` already left the loop, this line is only reached for servers that are up.

## Complete solution

```bash
#!/usr/bin/env bash
for server in anchovy barracuda cuttlefish dory eel flounder; do
  if [[ -e down/$server ]]; then
    echo "STOP: $server is down"
    break
  fi
  echo "patched $server"
done
```

## Trying it by hand
Create the marker with `mkdir -p down && touch down/dory`, then run the script. Remove it with `rm down/dory` and run again. Add a second marker for `flounder` and notice that it never gets mentioned, because the loop ended at dory.

## An alternative
You could set a flag variable and check it at the top of every round (`[[ $stopped ]] && continue`). That visits every remaining server for nothing and makes the logic harder to read. `break` states the intention in one word.
