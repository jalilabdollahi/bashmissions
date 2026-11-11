# Common Mistakes

- **Using single quotes around the data.** The shell does not expand variables in them, so the server receives the literal text `$email`.
  - Wrong: `curl -s -d 'email=$email&plan=$plan' URL`
  - Right: `curl -s -d "email=$email&plan=$plan" URL`
- **Unquoted `&`.** Without quotes the shell treats `&` as "run in background" and cuts the command in two.
  - Wrong: `curl -s -d email=$email&plan=$plan URL`
- **Adding `-G`, or putting the data into the URL, and expecting a POST.** Data in the URL (`?email=...`) is a GET with a query string; the endpoint answers `405 this endpoint only accepts POST`.
- **Sending `-X POST` without any data.** The body is empty and the server complains that the fields are missing. `-d` is what carries the data.
- **Swapping the fields.** `plan=$email&email=$plan` is valid form syntax and still wrong; read your argument order twice.
