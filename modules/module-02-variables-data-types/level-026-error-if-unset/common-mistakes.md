# Common Mistakes for Error If Unset

- Expecting the script to *continue* after the assertion fires. It doesn't — `${var:?...}` aborts the whole script (or returns from a function). That's the point.

- Using `:?` and ignoring the difference from `?`. `${var?msg}` only fires when `var` is unset; an explicitly-empty string passes silently. `${var:?msg}` treats both the same way.

- Forgetting that the message goes to **stderr**, not stdout. If you redirect only stdout, the error message still appears.

- Using `${var:?...}` in an interactive shell and being surprised that the shell doesn't quit. In an interactive shell it just returns 1 to the prompt; in a script it aborts.

- Putting it inside `[[ ]]` or `(( ))` and expecting normal behaviour. The expansion is parsed in those contexts but the abort still happens — usually not what you intend.
