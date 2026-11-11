# Debrief: Break Out Early

A loop does not have to run to the end of its list. `break` is the emergency exit: it ends the loop at once and Bash carries on with whatever follows `done`.

## How it works
When Bash executes `break` it abandons the rest of the current round and all remaining rounds of the innermost loop. The loop variable keeps its value, so after the loop `$server` still names the server that triggered the stop. That is handy when you want to report or log it afterwards.

`break` takes an optional number: `break 2` leaves two nested loops at once. You will meet nested loops in level 90, and you will rarely need the number form, but it is there.

Break is the right tool when continuing makes things worse, such as a rollout that must not go past a failure. The opposite problem, wanting to skip one item and keep going, is a different keyword.

## In real work
Fail-fast deploys, "stop at the first error" validations, giving up after enough retries, leaving an endless `while true` loop when a stop word arrives.

## Going further
What if one bad item should only be skipped, not end everything? That is `continue`, in the next level.
