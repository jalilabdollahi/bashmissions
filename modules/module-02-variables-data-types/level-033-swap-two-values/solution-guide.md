# Walkthrough: Swap Two Values

## The plan
Two values, two variables, and the rule that assigning to a variable erases what it held. The trick is to save one value before it gets erased.

## Step by step
Start with the naive version and trace it with `PRIMARY=dory STANDBY=eel`:

```bash
PRIMARY=$STANDBY    # PRIMARY is now eel - and "dory" is gone
STANDBY=$PRIMARY    # STANDBY gets eel again
```

Both variables end up as `eel`. Information was destroyed on the first line.

The fix is a temporary variable that keeps the old primary safe:

```bash
tmp=$PRIMARY        # tmp=dory
PRIMARY=$STANDBY    # PRIMARY=eel
STANDBY=$tmp        # STANDBY=dory
```

Print the state before and after. Printing is cheap and makes the change visible:

```bash
echo "before: primary=$PRIMARY standby=$STANDBY"
...
echo "after: primary=$PRIMARY standby=$STANDBY"
```

Assignments do not split words, so a name with a space such as `old dory` survives the shuffle without any quotes. (Only the `echo` line needs quoting, and it already has quotes.)

## Complete solution
```bash
#!/usr/bin/env bash
echo "before: primary=$PRIMARY standby=$STANDBY"
tmp=$PRIMARY
PRIMARY=$STANDBY
STANDBY=$tmp
echo "after: primary=$PRIMARY standby=$STANDBY"
```

## Try it by hand
```
PRIMARY=dory STANDBY=eel ./solution.sh
PRIMARY=marlin STANDBY=marlin ./solution.sh
```
Remove the `tmp` line and see what the first command prints.

## Alternative
Without a helper, you can print the values in reverse order and never touch the variables at all. That is why the objective asks you to really change them: once other lines of a longer script read `$PRIMARY`, they must see the new role.
