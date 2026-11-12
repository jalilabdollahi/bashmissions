# Common Mistakes

- **Checking dependencies while parsing.** A service may legitimately mention a dependency defined further down the file. Verify "unknown dependency" in a second pass, once every name is known.
- **Printing in hash order.** `for name in "${!deps[@]}"` has no stable order; two machines give two start orders. Sort every list you print with `LC_ALL=C sort`.
- **Counting duplicate dependencies twice.** `web: db db` leaves `unmet=2` but only one decrement ever arrives, and the service is never placed (a false cycle). Deduplicate each list.
- **Starting the whole fleet for one target.** `order web` must include only `web` and what it needs. Compute the transitive closure first, then sort only that subgraph.
- **Reporting just "cycle".** Without the path nobody knows which line to remove. Walk the leftover nodes and print `a -> b -> c -> a`.
- **Forgetting that stopping is the reverse of starting.** Stopping `db` before `web` takes the database away from a running service. Reverse the flattened start order.
