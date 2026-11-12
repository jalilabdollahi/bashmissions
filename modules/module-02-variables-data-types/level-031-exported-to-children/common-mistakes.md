# Common Mistakes

- **Forgetting to export.**
  Wrong: `REGION=north-pier` then `bash fixtures/child.sh` - the tool prints `REGION=[]`.
  Right: `export REGION=north-pier`.
- **Exporting everything "just in case".**
  Wrong: `export SCRATCH=...` leaks a private path (or a password) into every program you start.
  Right: export only what the child needs.
- **Expecting a child to change the parent.**
  A child can set `REGION=other` all it wants; your script still sees the old value afterwards. Variables never flow upwards.
- **Exporting after starting the child.**
  Wrong: `bash fixtures/child.sh` followed by `export REGION=...` - the child already started without it.
  Right: export first, run second.
