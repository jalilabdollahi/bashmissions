# Common Mistakes

- **Forgetting the plus.**
  Wrong: `url=:$PORT` replaces everything collected so far.
  Right: `url+=:$PORT`.
- **Spaces around `+=`.**
  Wrong: `url += :$PORT` runs a command called `url`.
  Right: `url+=:$PORT`.
- **Unquoted text with a space in a piece.**
  Wrong: `msg+= and more` (the second word becomes a command).
  Right: `msg+=" and more"`.
- **Gluing a name onto text without braces.**
  Wrong: `file=$STAGE_report` reads a variable called `STAGE_report`.
  Right: `file=${STAGE}_report` - remember the braces level.
