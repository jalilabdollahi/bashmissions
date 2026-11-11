# Common Mistakes

- **Forgetting the reset.** The rest of the line, and your prompt afterwards, stays coloured.
  Wrong: `printf '\033[31mFAIL %s\n' "$SERVICE"`
  Right: `printf '\033[31mFAIL\033[0m %s\n' "$SERVICE"`
- **Using echo without -e.** `echo "\033[32mOK"` prints the backslashes as text. Use printf.
- **Leaving out the bracket.** `\033 32m` is not a sequence. It is `\033[32m`.
- **Forgetting the final `m`.** Without it the terminal waits for the rest of the sequence and swallows your text.
- **Colouring the variable by accident.** The reset belongs right after the word, not at the end of the line.
