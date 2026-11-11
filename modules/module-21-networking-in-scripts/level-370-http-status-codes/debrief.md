# Debrief: HTTP Status Codes

## What you learned

An HTTP response has two parts that matter to a script: a **status code** and a **body**. The code is the server's verdict; the body is only the explanation. Checking the code is far more reliable than searching the page for the word "error", because a friendly error page is still an error.

## Under the hood

The first line of every response looks like `HTTP/1.1 503 Service Unavailable`. curl's `-w` option prints variables it collected during the transfer, `%{http_code}` among them. Since `-w` output goes to stdout, the body has to be redirected away with `-o`, otherwise they mix.

Two details trip people up. A redirect (301, 302) is a successful answer: "it moved", and curl does not follow it unless you add `-L`. And `000` is not an HTTP status; it is curl's way of saying "no response at all". Exit status and status code are different things: the exit status says whether curl managed to talk, the code says what the server replied.

## In real work

Monitoring scripts, deploy checks ("wait until the new version answers 200") and link checkers are all this loop with a different condition.

## Going further

You have only asked questions so far. In the next level you will send data to the server with a POST request.
