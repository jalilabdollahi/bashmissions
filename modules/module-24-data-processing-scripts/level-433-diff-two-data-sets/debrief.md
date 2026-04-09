# Diff Two Data Sets

This level practices **comm or diff**.

This is the kind of contract-driven scripting that helps larger automation stay testable and safe to change.

Focus on three things:

- Read the required inputs carefully.
- Match the expected output exactly.
- Return the correct exit status for success and failure cases.

A tiny working example looks like this:

```bash
./solution.sh fixtures/data.txt
# diff-two-data-sets:433:processed:3
```

Once you can make a script satisfy a small contract like this, you can reuse the same approach in bigger Bash programs.
