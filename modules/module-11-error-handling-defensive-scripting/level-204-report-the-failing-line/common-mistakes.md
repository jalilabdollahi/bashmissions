# Common Mistakes

- **Double quotes around the trap body.** Wrong: `trap "echo line $LINENO" ERR` prints the line of the trap command forever. Right: `trap 'echo line $LINENO' ERR`.
- **Using `$LINENO` inside a handler function.** Wrong: `report() { echo "line $LINENO"; }; trap report ERR` reports a line inside `report`. Right: `trap 'report $LINENO' ERR` and use `$1`.
- **Forgetting `set -e`.** The trap fires but the script carries on to print "packaged" after a failure. Right: ERR reports, `set -e` stops.
- **Registering the trap after the failing command.** A trap set on line 20 cannot report the failure on line 6.
- **Printing to stdout.** Wrong: `echo "error ..."` pollutes the output a calling script may be parsing. Right: `echo "error ..." >&2`.
