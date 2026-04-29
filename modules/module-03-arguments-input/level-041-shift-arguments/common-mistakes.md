# Common Mistakes for Shift Arguments

- Leaving variables unquoted, which breaks inputs containing spaces.
- Printing extra labels, prompts, or debug text that the exact-output tests do not expect.
- Forgetting that `set -u` makes missing positional parameters an immediate error.
- Solving the previous level's pattern instead of the specific concept listed in `CURRICULUM.md`.
