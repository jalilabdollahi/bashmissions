# Common Mistakes

- **Deleting or mistyping the shebang.** `# !/usr/bin/env bash` (with a space) or `#/usr/bin/env bash` is just an ordinary comment.
  Wrong: `#!usr/bin/env bash`
  Right: `#!/usr/bin/env bash`
- **Forgetting that echo is the command.** A bare line of text is not printed, Bash tries to run it as a program.
  Wrong: `Hello, Lanternfish!`
  Right: `echo "Hello, Lanternfish!"`
- **Changing the text.** The check is exact, so `Hello Lanternfish` (no comma) or `hello, lanternfish!` will fail. Copy the line from the objective.
- **Leaving the TODO comment and nothing else.** Lines that start with `#` are ignored by Bash, so a script made only of comments prints nothing.
