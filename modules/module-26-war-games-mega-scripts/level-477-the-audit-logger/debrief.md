# The Audit Logger

This level practices **Tamper-evident append-only log**.

This mirrors production-style scripting, where a script needs to behave consistently across both success and failure paths.

Focus on three things:

- Read the required inputs carefully.
- Match the expected output exactly.
- Return the correct exit status for success and failure cases.

A tiny working example looks like this:

```bash
./solution.sh fixtures/data.txt audit
# the-audit-logger:477:expert:audit
```

Once you can make a script satisfy a small contract like this, you can reuse the same approach in bigger Bash programs.
