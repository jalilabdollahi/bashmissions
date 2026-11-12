# Common Mistakes

- **Trusting the order of for-in.** `for (c in rows) print ...` may print customers in any order, and the order differs between machines. Pipe into `sort`.
- **Counting the header as a customer.** Without `NR > 1`, a row `customer` with value `gb` appears in the report. Skip it, or test for it explicitly.
- **Using the wrong separator.** Without `-F,` the whole line is field 1, `$2` is empty, and everything lands in one group with an empty name.
- **Reading a missing key.** `if (a[$1] == "")` creates the element as a side effect. To test for a key without creating it, use `if ($1 in a)`.
- **Forgetting that array values are not reset.** Inside `END`, `delete rows` or a new awk run is needed to start fresh; arrays keep everything from the whole file.
