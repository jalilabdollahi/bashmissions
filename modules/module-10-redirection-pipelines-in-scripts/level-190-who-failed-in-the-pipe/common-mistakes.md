# Common Mistakes

- **Reading PIPESTATUS after another command.**
  - Wrong: `a | b | c; echo "running done"; echo "${PIPESTATUS[0]}"` (this reports the first echo)
  - Right: `a | b | c; status=("${PIPESTATUS[@]}")` on the very next line
- **Using `$?` as if it covered the whole pipeline.** It is the last stage only.
  - Wrong: `fetch-logs | scrub-pii | ship-lines; (( $? == 0 )) && echo ok`
  - Right: check every element of the copied array
- **Copying with the wrong quoting.** Unquoted `${PIPESTATUS[@]}` is fine for integers, but a bare `status=$PIPESTATUS` copies only element 0.
  - Wrong: `status=$PIPESTATUS`
  - Right: `status=("${PIPESTATUS[@]}")`
- **Off-by-one between index and stage number.** Arrays start at 0, humans count from 1.
  - Wrong: `echo "failed at stage $i"` for index 0
  - Right: `echo "failed at stage $(( i + 1 ))"`
- **Using it in a pipeline that is inside a subshell or `$( )`.** The array lives in the shell that ran the pipeline.
  - Right: run the pipeline in your own shell and read PIPESTATUS there
