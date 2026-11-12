# Common Mistakes

- **Sending both to stdout.** The warning ends up in the customer's mail.
  Wrong: `echo "warning: disk" `
  Right: `echo "warning: disk" >&2`
- **Reversing the arrow.** `2>&1` sends stderr into stdout, the opposite of what you want here.
  Wrong: `echo "warning" 2>&1`
  Right: `echo "warning" >&2`
- **Missing the ampersand.** `echo "warning" >2` writes into a file called `2`.
  Right: `echo "warning" >&2`
- **Putting >&2 inside the quotes.** It becomes part of the printed text.
