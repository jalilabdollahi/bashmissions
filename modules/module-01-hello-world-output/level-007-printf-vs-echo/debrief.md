# printf vs echo

This level practices **choosing the right output tool**.

This is a foundation skill. Small shell scripts become much easier once you can reliably read inputs and print exactly the right output.

Focus on three things:

- Read the required inputs carefully.
- Match the expected output exactly.
- Return the correct exit status for success and failure cases.

A tiny working example looks like this:

```bash
./solution.sh alpha beta
# LEVEL 7: printf vs echo | alpha | beta
```

Once you can make a script satisfy a small contract like this, you can reuse the same approach in bigger Bash programs.
