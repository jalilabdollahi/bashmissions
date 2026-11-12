# Walkthrough: Collapse Repeated Messages

## The plan
A repeat can only be recognised by comparing a line with the one before it, so
the script carries two pieces of memory from line to line: the previous
message, and how many extra copies of it have gone past unprinted. When a
different message arrives the run is over, and *then* (not before) the note
"last message repeated R times" can be printed.

## Step by step
1. Get the message out of a line. The timestamp differs every time, so it must
   not take part in the comparison. `${line#* }` deletes everything up to and
   including the first space:

   ```bash
   msg=${line#* }
   ```

   A line that contains no space at all would be left unchanged by that
   expansion, so the answer treats it as having an empty message.

2. Compare with `prev`. If it is the same message again, only count it and go
   to the next line with `continue`; nothing is printed yet.

3. Otherwise the run has ended. Print the pending note first (a `flush`
   function: nothing for 0, `1 time` for one, `R times` for more), reset the
   counter, then print the new line unchanged and remember its message.

4. After the loop, call `flush` again. If the log ends in the middle of a
   flood, the last run is still waiting for a "different line" that will never
   come. This forgotten final flush is the classic bug of this kind of script.

## Try it by hand
```
printf '10:00:01 down\n10:00:02 down\n10:00:03 up\n' | ./solution.sh
printf '10:00:01 down\n10:00:02 down\n' | ./solution.sh
```

## Alternative
`uniq` folds adjacent duplicates and `uniq -c` counts them, but it compares whole
lines, and the timestamps make every line unique. You would first have to
split the timestamps off and glue them back, and it cannot print a "last
message repeated" note in syslog style. A loop gives full control of the output.
