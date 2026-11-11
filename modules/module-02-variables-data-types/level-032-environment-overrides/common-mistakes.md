# Common Mistakes

- **Wrong order in the chain.**
  Wrong: `${PORT:-${APP_PORT:-8080}}` lets the generic setting beat the specific one.
  Right: `${APP_PORT:-${PORT:-8080}}` - most specific first.
- **Losing a closing brace.**
  Wrong: `${APP_PORT:-${PORT:-8080}` (one `}` short) swallows the rest of the line.
  Right: count them: two `${` need two `}`.
- **Assigning over the original.**
  Wrong: `APP_PORT=${APP_PORT:-8080}` - you can no longer tell whether the caller provided it.
  Right: resolve into a separate variable, `port=${APP_PORT:-8080}`.
- **Forgetting that empty falls through.** With the colon, `APP_PORT=` means "not set", so `PORT` is consulted. If that surprises you, re-read the fallback levels.
