# Common Mistakes for Substring Extraction

- Forgetting that offsets are **0-based**. `${text:1}` skips the first character; `${text:0}` returns the whole string.

- Negative offset without a leading space: `${text:-3}` is parsed as default-value expansion ("if `text` is unset/empty, use 3"). Always write `${text: -3}` for negative offsets.

- Confusing `${text:1:4}` with `${text:1,4}`. Bash uses `:` as the separator between offset and length; the comma form belongs to other shells.

- Using `${text:offset:length}` on a positional parameter. It works for `$1`, `$2`, etc. (`${1:0:3}`), but with extra parsing rules — when in doubt, copy to a named variable first.

- Out-of-range thinking: `${text:5:0}` returns an empty string (zero-length slice), not an error. Distinguish "I want zero characters" from "I want everything from offset 5".
