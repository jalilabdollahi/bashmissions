# Debrief: Load a .env File Safely

The mental model: **configuration is data, and data must never be code.** A file
that people other than the script's author can edit must be read, not run.
`source` hands every character to the shell parser, which treats `$(...)`,
backticks, `;` and `&` as instructions. So the customer who types a clever value
is no longer configuring your service; they are logged in to it.

Reading the file yourself changes the contract. You decide what a valid line
looks like (a key pattern, one `=`, optional quotes), and everything outside the
contract is skipped and reported instead of obeyed. `export "$key=$value"` is the
safe hand-off: the value is already a finished string, so there is no second
round of expansion.

Under the hood: `[[ str =~ regex ]]` stores the whole match in `BASH_REMATCH[0]`
and each parenthesised group in the next slots. Parsing with a regex rather than
`cut -d=` is what keeps values containing `=` intact.

In real work this shows up in Docker and systemd `EnvironmentFile`, deploy
tools, `direnv` and CI runners; many of them parse with exactly these rules
precisely because they cannot trust the file.

Going further: this file overwrote whatever was in the environment. Real tools
usually rank their sources, so the next level layers built-in defaults, a config
file and the environment, and decides who wins.
