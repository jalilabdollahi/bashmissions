# Debrief: Iterate Values

`for x in "${arr[@]}"` is the standard way to visit every element of an array. The loop variable gets a copy of each value in turn, so the loop works without any index arithmetic.

## How it works
Before the loop starts, Bash expands `"${amounts[@]}"` into a list of words, one per element, and then runs the body once for each. This is the same expansion you met in "All Elements Safely"; the `for` loop is just a consumer for it. Because the expansion happens once up front, changing the array inside the loop does not change what the loop visits.

The loop variable is a copy. Writing `amount=5` in the body changes `amount` only and leaves the array alone. If you need to modify the elements, you need to know where they are, which means iterating indexes (next level).

Zero elements means zero iterations. There is no "empty list" error to catch, which is why accumulating patterns (a total, a counter, a filtered copy) work for any input size without a guard.

## In real work
Summing, counting, filtering and checking: "any host down?", "total disk used", "which files are older than 30 days". If the answer depends on the values only, this is the loop.

## Going further
Some jobs need the position as well: "slot 3 holds ...". Iterating the indexes is the next level.
