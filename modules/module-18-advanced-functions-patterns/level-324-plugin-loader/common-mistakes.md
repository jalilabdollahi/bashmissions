# Common Mistakes

- **Running the plugin instead of sourcing it.** Wrong: `bash "$file"` or `"$file"`. The functions are defined in a child process that exits, so `plugin_NAME` is "command not found". Right: `source "$file"`.
- **Forgetting the empty folder.** Wrong: loop without `nullglob` over an empty directory tries to source the literal `plugins/*.sh`. Right: `shopt -s nullglob` before the loop (or `[[ -e $file ]] || continue`).
- **Keeping the suffix in the function name.** Wrong: `"plugin_${file##*/}"` calls `plugin_demo.sh`. Right: strip it too: `name=${name%.sh}`.
- **Quoting the glob.** Wrong: `for f in "$dir/*.sh"` is one literal word, never expanded. Right: `"$dir"/*.sh`: quote the variable, leave the star bare.
- **Parsing `ls`.** Wrong: `for f in $(ls "$dir")` splits on spaces and includes non-plugins. Right: a glob.
