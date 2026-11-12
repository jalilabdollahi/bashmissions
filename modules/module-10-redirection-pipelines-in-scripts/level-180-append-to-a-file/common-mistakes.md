# Common Mistakes

- **Using `>` inside the loop.** Only the last line survives.
  - Wrong: `printf '[audit] %s\n' "$event" > audit.log`
  - Right: `printf '[audit] %s\n' "$event" >> audit.log`
- **Using `>` once before the loop "to create the file".** It wipes the history on every run.
  - Wrong: `> audit.log` at the top of the script
  - Right: no setup line at all; `>>` creates the file itself
- **Forgetting the newline.** The next append glues itself to the previous line.
  - Wrong: `printf '[audit] %s' "$event" >> audit.log`
  - Right: `printf '[audit] %s\n' "$event" >> audit.log`
- **Mistyping the operator as `> >`.** That is a syntax error, because the two characters must touch.
  - Wrong: `echo hi > > audit.log`
  - Right: `echo hi >> audit.log`
