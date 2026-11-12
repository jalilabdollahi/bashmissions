# Debrief: The User Auditor

An access audit is bookkeeping: for every account, ask the same dull questions, and
for every directory ask whether anyone owns it. The two shapes that make the script
manageable are **lookup tables** and **uniform records**. Once `shadow` and the
last-login list are in associative arrays, each check is a one-liner; once every
finding is a `RANK|KIND|USER|SEV|DETAIL` string, sorting, counting and printing
become trivial, and adding a new check later means adding one `add` call.

The details are where audits go wrong. Ignoring a user must not turn that user's
home into an "orphan". An empty password is not the same as a missing shadow entry.
`nologin` accounts are not stale, they are just not people. And permissions are
read from `ls -l` rather than `stat`, the same trick that keeps a script working
on macOS and Linux alike.

In practice audits like this run weekly from cron or in CI against configuration
dumps, with the allow-list (`--ignore`) reviewed in a pull request, so the exception
list itself becomes auditable. The exit status (0 clean, 1 findings) lets a pipeline
block a release.

Going further: next you will watch a live system instead of a file dump, polling an
API and reacting only when its state changes.
