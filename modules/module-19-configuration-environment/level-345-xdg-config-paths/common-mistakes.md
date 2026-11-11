# Common Mistakes

- **Using `${XDG_CONFIG_HOME-$HOME/.config}` (no colon).** Wrong: with `XDG_CONFIG_HOME=` (empty) the base becomes the empty string and the path turns into `/pelican/config.ini`. Right: `:-`, or the `!= /*` test, so empty falls back.
- **Trusting a relative value.** Wrong: `XDG_CONFIG_HOME=relative/dir` makes the answer depend on the current directory. Right: only accept values that start with `/`.
- **Searching both bases.** Wrong: looping over `$XDG_CONFIG_HOME` and then `~/.config` finds files the user deliberately moved away from. Right: choose one base and consult only it.
- **Testing with `-e` instead of `-f`.** Wrong: `[[ -e $path ]]` accepts a directory called `config.ini`. Right: `[[ -f $path ]]`.
- **Hard-coding `/home/someone`.** Wrong: `path=/home/jalil/.config/...` breaks on every other machine. Right: always build paths from `$HOME`.
