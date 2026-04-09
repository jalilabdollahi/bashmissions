# Check Key Exists

This level practices **`[[ -v map[key] ]]`**.

This pattern shows up in everyday automation work, where scripts need to turn files and arguments into predictable output.

Focus on three things:

- Read the required inputs carefully.
- Match the expected output exactly.
- Return the correct exit status for success and failure cases.

A tiny working example looks like this:

```bash
./solution.sh alpha beta
# LEVEL 174: Check Key Exists | alpha | beta
```

Once you can make a script satisfy a small contract like this, you can reuse the same approach in bigger Bash programs.
