# Common Mistakes

- **Using `elif` between the three tests.** The tests are independent; with `elif` only the first true one would run.
  - Wrong: `if [[ -r $p ]]; then r=r; elif [[ -w $p ]]; then w=w; ...`
  - Right: three separate `if` blocks
- **Testing the wrong thing with `-x` on a directory.** `-x` means "may enter", not "is a program".
  - Wrong: assuming `-x` is only true for scripts
  - Right: combine with `-f` when you need "a runnable regular file": `[[ -f $p && -x $p ]]`
- **Trusting the mode bits instead of the user.** A file with mode 640 is not readable by someone outside its group.
  - Wrong: parsing `ls -l` for an `r` in the first column
  - Right: `[[ -r $path ]]`
- **Forgetting to handle the missing path.** All three tests are false for a path that does not exist, so the output `---` would be misleading.
  - Wrong: no `-e` check, printing `ghost.sh: ---`
  - Right: check `-e` first and exit with an error
