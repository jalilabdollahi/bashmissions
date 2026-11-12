# Walkthrough: Error Messages That Help

## The plan
The starter's logic is fine: right checks, right order, right exit codes. Only the
text is poor. Each of the three failures gets a two-line message built from the
facts the script already knows.

## The three questions
| question | where the answer comes from |
|---|---|
| What went wrong? | the first line: `error: ...` |
| Where? | the variables: `$config`, `$lineno`, `$line` |
| How do I fix it? | the second line, indented: `fix: ...` |

## Step by step
1. All messages go to stderr: a script whose output is piped to another program
   should not leak errors into the data. Add `>&2` to every `echo` of an error.

2. Missing file. We know its name, and we know the remedy:

   ```bash
   echo "error: config file not found: $config" >&2
   echo "  fix: create it with: lanternctl init $config" >&2
   ```

3. A malformed line. The loop already counts `lineno`, and the line itself is in
   `$line`. The quotes around it show leading and trailing spaces, which would be
   invisible otherwise:

   ```bash
   echo "error: $config:$lineno: not a key=value line: \"$line\"" >&2
   echo "  fix: write it as name=value, or start the line with # to comment it out" >&2
   ```
   `file:line:` is the format editors and terminals recognise, so many tools let
   you click straight to the place.

4. The missing key names the key and shows a valid example.

5. Keep exit 1 after each pair; the final success line stays on stdout.

## Try it by hand
```bash
printf 'domain=a.example\nport 80\n' > t.conf
./solution.sh t.conf
./solution.sh t.conf 2>/dev/null     # prints nothing: it all went to stderr
```

## Alternative
A small `die()` function that prints both lines and exits would remove the
repetition. With only three errors, spelling them out keeps each message easy
to read and to compare with the spec.
