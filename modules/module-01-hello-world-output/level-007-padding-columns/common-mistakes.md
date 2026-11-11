# Common Mistakes

- **Forgetting the minus for text.** Without it the name is pushed to the right of its box.
  Wrong: `%10s`  gives `      dory`
  Right: `%-10s` gives `dory      `
- **Padding by hand with spaces.** It breaks when a name is longer or shorter than you expected.
  Wrong: `echo "[dory      ]"`
  Right: `printf '[%-10s]\n' "$HOST"`
- **Using %d for the header word.** printf rejects text for a number placeholder. The header "USERS" needs `%5s`.
- **Counting the width wrong.** `%-10s` is the whole box, not the number of spaces added.
