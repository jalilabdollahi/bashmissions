# Debrief: Find the Project Config

The mental model: **context is found by looking outward from where you are.** A
project config applies to everything inside the project's folder, so the tool
searches up from the current directory and uses the first match; the closest file
is the most specific one, so it wins. This is how `git`, `npm`, `eslint`,
`.editorconfig` and `.envrc` find their files, and why you can run them from any
subfolder.

Two safety ideas deserve attention. The first is normalisation: compare real paths
produced by `cd ... && pwd -P`, never the strings the user typed, because one
place has many spellings. The second is the boundary. A loop that moves up by
`dirname` ends at `/` at the latest, but by then it has read files that belong to
other projects or other users, which is a security problem (a file planted in a
shared parent folder would configure your tool). Stopping at an explicit root keeps
the search inside the territory you trust.

Under the hood, `dirname` is purely textual: it chops the last path component and
never touches the disk, so it is cheap and cannot fail on missing folders.

Going further: configuration values are text, but programs need numbers and flags.
The next level checks that integers are integers, booleans are booleans and
enumerations are among the allowed words, before the rest of the script trusts
them.
