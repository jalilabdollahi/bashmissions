# Common Mistakes

- **Putting commas between the words.** Bash splits on spaces, not commas.
  Wrong: `for name in anchovy, barracuda, dory; do` (the names keep their commas)
  Right: `for name in anchovy barracuda dory; do`
- **Forgetting the dollar sign inside the body.** The variable name alone is just text.
  Wrong: `echo "refreshing banner on name"`
  Right: `echo "refreshing banner on $name"`
- **Closing line inside the loop.** If the final echo sits before `done`, it prints five times.
  Wrong: the "all banners refreshed" line placed above `done`
  Right: place it after `done` so it runs once.
- **Missing `do` or `done`.** Bash reports a syntax error such as "unexpected end of file". Every `for` needs both.
