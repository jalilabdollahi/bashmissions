# Common Mistakes

- **Forgetting the header.** curl then labels the body as a web form and the server answers `unsupported media type`.
  - Right: `-H 'Content-Type: application/json'`
- **Quoting the number.** `"amount":"120"` is a string, not a number; many APIs reject it.
  - Wrong: `json="{\"amount\":\"$amount\"}"`
  - Right: `json="{\"amount\":$amount}"`
- **Not quoting `"$json"` on the curl line.** A name such as `Tidewater Books` splits into two words and curl treats the second as a URL.
  - Right: `-d "$json"`
- **Pasting unchecked text into JSON.** A customer called `The "Anchor" Pub` breaks the document. Validate or refuse such input before you build the body.
- **Single quotes around the whole JSON when it has variables.** `'{"customer":"$customer"}'` sends the dollar sign literally.
