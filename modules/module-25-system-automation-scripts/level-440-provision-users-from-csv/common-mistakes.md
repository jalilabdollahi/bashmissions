# Common Mistakes

- **Matching existing users without the colon.** `grep -q "^$user" passwd` treats `ann` as present when only `anna` exists.
  - Right: `grep -q "^$user:" passwd`
- **Letting a failed `useradd` end the script.** Under `set -e`, `useradd ...` on row 3 means rows 4 to 40 never run.
  - Right: `if useradd ...; then ...; else ...; fi`
- **Trusting the CSV.** A name like `x; rm -r y` or `Bad Name!` should never reach `useradd`.
  - Right: check `[[ $user =~ ^[a-z][a-z0-9_-]{2,15}$ ]]` first.
- **Quoting the regex.** `[[ $u =~ "^[a-z]+$" ]]` compares literal text, so it never matches.
  - Right: keep the pattern unquoted, or store it in a variable.
- **Forgetting the header.** Without skipping line 1 you try to create a user called `username`.
