# Common Mistakes

- **Banning any two dots.** Wrong: `[[ $name == *..* ]]` also blocks `summary..final.txt`. Right: match only whole `..` components, with `..|../*|*/../*|*/..`.
- **"Cleaning" instead of rejecting.** Wrong: `name=${name//..\/}` turns `....//x` into `../x`. Right: refuse the whole request.
- **Forgetting the end of the name.** Wrong: patterns `../*` and `*/../*` allow `docs/..`, which resolves to the parent when used with `cd` or `cat`. Right: add `*/..` and bare `..`.
- **Checking after reading.** Wrong: `cat "public/$name"` first and validating later leaks the content. Right: validate first.
- **Forgetting absolute names.** Wrong: only testing for `..` lets `/etc/hosts` through scripts that use `$name` directly. Right: also refuse `/*`.
