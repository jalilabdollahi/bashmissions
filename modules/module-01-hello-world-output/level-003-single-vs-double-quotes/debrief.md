# Single vs Double Quotes

This level practices **quoting differences**.

This is a key Bash skill. Correct quote usage prevents subtle bugs in scripts.

Focus on three things:

- Read the required inputs carefully.
- Understand when variables expand.
- Match the expected two-line output exactly.

A tiny working example looks like this:

```bash
./solution.sh alpha
# single: $name
# double: alpha
```

Once you can make a script satisfy a small contract like this, you can reuse the same approach in bigger Bash programs.
