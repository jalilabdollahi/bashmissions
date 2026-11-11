# Debrief: Where Was This Defined?

`$0` answers "what did the user start?". `${BASH_SOURCE[0]}` answers "which file
is this code in?". For a single script they are the same, so people use `$0`
for everything, and it works until the day somebody sources the file. Then `$0`
is the caller, and any message, path or decision built on it is wrong.

`BASH_SOURCE` is an array that follows the call stack just like `FUNCNAME`: the
entry at index 0 is the file of the code being executed, index 1 the file of
the code that called it, and so on. That makes it the right tool for two jobs
in library code. The first is reporting: messages such as "defined in
lib/hosts.sh" tell you which copy of a function you are looking at. The second
is locating siblings: `$(dirname "${BASH_SOURCE[0]}")` is the library's own
folder, so it can load its data files or other libraries without depending on
the caller's working directory.

The "main guard" you wrote, `[[ ${BASH_SOURCE[0]} == "$0" ]]`, is Bash's cousin of
Python's `if __name__ == "__main__"`. It lets one file be a tool and a library,
and makes functions testable: a test script can `source` the file and call
functions one at a time, which is where this module is going.

Going further: errors need context too. The next level builds a trap that
reports the failing command, its line, and its exit status.
