# Debrief: Recursion: Directory Tree

The factorial level used recursion on a number. This one uses it on its natural
habitat: nested data. A folder tree is defined in terms of itself (a folder holds
files and folders), so a function that handles one folder and calls itself for each
sub-folder follows the data exactly. There is no explicit base case because the
leaves end the recursion on their own: folders without sub-folders make no further
calls.

The state travels in the arguments. `indent` grows by two spaces at each level
and, because it is a `local` variable, each call keeps its own copy. When a deeper
call finishes, the caller's `indent` is untouched and the next sibling is printed
at the right depth. If `indent` were global, the tree would drift further right
after every folder.

The same pattern appears in real tooling: finding files, totalling disk usage,
copying nested configurations, deleting a directory with its contents. `find` does
this walk for you in C; writing it once in Bash shows you what it does.

Two practical limits: symbolic links can make a tree loop forever, so serious
tools track what they have visited, and the glob skips hidden files, which a real
audit may want to include (`shopt -s dotglob`).

Going further: next you will pass a function itself to another function, so one
walker can do many jobs.
