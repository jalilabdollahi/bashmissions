# Common Mistakes

- **chmod after the write.** Wrong: `echo "$key" > f; chmod 600 f` leaves a readable window. Right: `( umask 077; echo "$key" > f )`.
- **Setting the umask globally and forgetting it.** Wrong: `umask 077` at the top makes `index.txt` private too, and the report team cannot read it. Right: wrap only the secret part in a subshell.
- **Reading the mask backwards.** Wrong: `umask 600` thinking "files get 600". The mask is subtracted: `umask 600` would leave group/other with execute-only rights on folders. Right: `umask 077` to *remove* group/other bits.
- **Forgetting the folder.** Wrong: creating `secrets/` before setting the mask gives a 755 folder, so names inside are listable. Right: create it inside the same umask scope.
- **Expecting umask to fix old files.** Wrong: running `umask 077` and then `echo >> existing` keeps the existing mode. Right: use `chmod` once for files that already exist.
