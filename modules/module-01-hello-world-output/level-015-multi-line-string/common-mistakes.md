# Common Mistakes for Multi-line String

- Indenting the closing `EOF` with spaces. The delimiter must start at column 1, or the heredoc never ends and Bash will "hang" reading the rest of the file.

- Putting anything (even a space) after the closing `EOF`. `EOF ` will not match.

- Using three `echo` statements when the level asks for a heredoc. Both produce the same output, but you miss the lesson — and `echo` doesn't scale to a 50-line config block.

- Forgetting that `$VAR` expands inside an unquoted heredoc. If you want literal `$VAR` text, use `<<'EOF'` (quote the delimiter).

- Trailing-newline anxiety. A heredoc always ends with a newline before `EOF`, and `cat` preserves it. The runner strips one trailing newline before comparing, so the `\n` after `line three` is fine.
