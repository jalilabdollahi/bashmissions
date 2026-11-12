# Debrief: Changelog from Commits

The mental model: **classify first, present second.** A report is rarely in the
same order as its input. By collecting items into named buckets while you read,
and printing the buckets afterwards, you control the layout completely:
sections in a fixed order, empty ones omitted, input order preserved inside.

Convention is what makes this possible. `feat:` and `fix:` are a tiny
agreement that turns free text into data, and a regex is the contract-checker.
Notice what happens at the edges: a subject that breaks the convention is not
an error, it falls through to "Other", so the changelog never loses a commit.
Good tools degrade gracefully like this.

Two Bash details are worth keeping. Optional regex groups keep their index
whether or not they matched, so the numbering never shifts. And arrays are the
natural "list" type: appending with `+=(...)` and passing them on with
`"${list[@]}"` preserves items with spaces.

In real work this is what `conventional-changelog`, `release-please` and
GitHub's generated release notes do, usually reading `git log` between two
tags.

Going further: a changelog needs commits since the previous release, and for
that something must create release tags. The next level drives `git tag` safely.
