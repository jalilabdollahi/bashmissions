# Float Arithmetic with bc

This level practices **`echo "scale=2; 1/3" \| bc`**.

This pattern shows up in everyday automation work, where scripts need to turn files and arguments into predictable output.

Focus on three things:

- Read the required inputs carefully.
- Match the expected output exactly.
- Return the correct exit status for success and failure cases.

A tiny working example looks like this:

```bash
./solution.sh alpha beta
# LEVEL 151: Float Arithmetic with bc | alpha | beta
```

Once you can make a script satisfy a small contract like this, you can reuse the same approach in bigger Bash programs.
