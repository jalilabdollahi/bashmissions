# Create Temp File

This level practices **`mktemp`**.

This pattern shows up in everyday automation work, where scripts need to turn files and arguments into predictable output.

Focus on three things:

- Read the required inputs carefully.
- Match the expected output exactly.
- Return the correct exit status for success and failure cases.

A tiny working example looks like this:

```bash
./solution.sh fixtures/data.txt
# create-temp-file:243:processed:3
```

Once you can make a script satisfy a small contract like this, you can reuse the same approach in bigger Bash programs.
