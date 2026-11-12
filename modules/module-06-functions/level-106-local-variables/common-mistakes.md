# Common Mistakes

- **Forgetting `local`.** Without it `subtotal` and `total` become global and may
  overwrite a caller's variable of the same name.
- **`local` outside a function.** At the top level of the script it fails with
  "can only be used in a function". It is for function bodies only.
- **Hiding errors with `local x=$(cmd)`.** The `$?` you see is `local`'s (always 0).
  Right: `local x` on one line, `x=$(cmd)` on the next.
- **Assuming `local` means "private".** A function called from yours can still read
  your local variables. It only protects the *callers* from your names.
- **Testing the leak through `$( )`.** `$(line_total ...)` runs in a subshell and
  hides leaks. Call the function plainly to see whether it escapes.
