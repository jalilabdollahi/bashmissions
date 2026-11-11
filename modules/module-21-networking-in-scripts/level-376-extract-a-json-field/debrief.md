# Debrief: Extract a JSON Field

## What you learned

For a tiny, flat, predictable reply, JSON is just text and `sed -E` with a capture group is enough to lift out one value. The craft is in the pattern: anchor on the quoted key, tolerate the spacing a real server might use, and stop at the right delimiter.

## Under the hood

`s/.*"plan": *"?([^",}]*).*/\1/p` replaces the whole line with whatever group 1 captured. Because `.*` is greedy it matches as much as possible before the key, which would be a problem if a key appeared twice; here keys are unique. Including the quotes in the pattern is what separates `"id"` from `"customer_id"`; matching bare `id` would have returned the wrong customer.

This approach has hard limits, and a professional knows them. Values containing commas, escaped quotes, nested objects, arrays, or a reply spread over many lines will all defeat it. The moment the shape is not under your control, reach for a real parser such as `jq` (where installed) or write that part in a language with a JSON library.

## In real work

Pulling a version string, an ID or a state out of a small API reply is an everyday chore in deploy and monitoring scripts, and a one-line `sed` is the lightest tool that does it without adding a dependency.

## Going further

APIs return long lists in slices called pages. Next, you will follow the "next page" link until the list ends.
