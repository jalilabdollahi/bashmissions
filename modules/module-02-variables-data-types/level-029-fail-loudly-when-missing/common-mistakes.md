# Common Mistakes

- **Using `:-` for a required setting.**
  Wrong: `host=${DB_HOST:-localhost}` quietly dumps the wrong database.
  Right: `host=${DB_HOST:?DB_HOST must be set}`.
- **Forgetting the message.**
  Wrong: `${DB_HOST:?}` still stops, but prints only the generic `parameter null or not set`.
  Right: write what the operator should do: `${DB_HOST:?DB_HOST must be set}`.
- **Checking too late.**
  Wrong: doing slow or destructive work, then reading the required setting at the end.
  Right: read required settings at the top, before any work.
- **Typing a closing brace in the message.** A `}` ends the expansion early, so keep the message free of braces.
