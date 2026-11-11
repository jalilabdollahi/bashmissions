# Walkthrough: Alert Webhook

## The plan
A webhook is a URL that turns an HTTP POST into a chat message. The script
builds a small JSON document, posts it, and then looks at the HTTP status
code, because "curl ran" does not mean "the alert arrived".

## Step by step
1. Validate first: three arguments, a known severity, and a configured URL.
   Reading the URL from the environment keeps the secret out of the script and
   out of version control.

2. Build the JSON. It is only text, but the message is untrusted: a `"` in it
   would end the string early and produce invalid JSON. Escape backslashes
   first, then quotes (reverse the order and you would escape the backslashes
   you just added):

   ```bash
   message=${message//\\/\\\\}
   message=${message//\"/\\\"}
   body="{\"host\":\"$host\",\"severity\":\"$severity\",\"text\":\"$message\"}"
   ```

3. Send with curl and capture only the status code:

   ```bash
   status=$(curl -sS -o /dev/null -w '%{http_code}' --max-time 5 \
     -X POST -H 'Content-Type: application/json' -d "$body" "$WEBHOOK_URL") || true
   ```

   `-sS` hides the progress meter but still prints errors, `-o /dev/null`
   discards the reply, `-w` prints the code. When the server is unreachable
   curl fails and prints `000`, so `|| true` stops `set -e` ending the script
   before you can report it.

4. Judge the status. `[[ $status == 2?? ]]` matches 200 to 299. Failure goes to
   stderr with exit 1, so a calling script can tell.

## Try it by hand
```
export WEBHOOK_URL=https://chat.example/hooks/oncall
./solution.sh eel critical 'disk is 97% full'
FAKE_HTTP_STATUS=503 ./solution.sh eel critical 'disk is 97% full'; echo $?
cat .curl.log
```
`curl` here is a stub; `.curl.log` shows the request it received.

## Alternative
`curl --fail` makes curl exit non-zero on HTTP errors, which is shorter, but then
you lose the actual code to put in the message. Printing the status code is
more informative for whoever debugs a missed alert.
