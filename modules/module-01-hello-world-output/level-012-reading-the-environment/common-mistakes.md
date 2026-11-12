# Common Mistakes

- **Single quotes around the variable.** You get the names instead of the values.
  Wrong: `echo 'You are $USER'`
  Right: `echo "You are $USER"`
- **Forgetting the dollar sign.** The word is just text.
  Wrong: `echo "You are USER"`
  Right: `echo "You are $USER"`
- **Adding a space after the dollar.** `$ USER` is not a variable.
- **Hard-coding your own name.** It passes on your machine and fails the test that changes the user.
