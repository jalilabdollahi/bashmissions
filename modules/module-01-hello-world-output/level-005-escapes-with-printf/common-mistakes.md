# Common Mistakes

- **Forgetting the final \n.** printf adds no newline by itself, so the shell prompt ends up glued to your last row.
  Wrong: `printf 'done'`
  Right: `printf 'done\n'`
- **Typing \t with a literal Tab key.** Editors may convert it to spaces, and the output is no longer a tab. Write the two characters `\t`.
- **Using the wrong slash.** `/n` and `/t` are just text. Right: `\n` and `\t`.
- **Expecting escapes from echo.** Plain `echo "a\tb"` prints a backslash and a t. Use printf.
