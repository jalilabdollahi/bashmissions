# Debrief: Fetch a Page

## What you learned

A web page is just the answer to a question. `curl URL` asks the question (an HTTP GET request) and prints the answer, called the response body, on stdout. That makes the web look like any other command in a pipeline: you can capture it with `$(...)`, test it, trim it and print it.

## Under the hood

curl opens a connection, sends `GET /components/web.txt`, reads the reply and writes the body to stdout. Anything else it wants to say, the progress bar and error messages, goes to stderr. That split is why `-s` exists: scripts want a clean stdout and a stderr they control.

The exit status of curl answers a narrow question: "did I manage to complete the request?" Name lookup failed, connection refused or a timeout all give non-zero. A server that answers "404 Not Found" still counts as a completed request, so curl exits 0. Remember that sentence; the next levels are built on it.

## In real work

Status pages, health endpoints, "what is my public IP" services, release metadata: a surprising amount of operations work is "fetch a small text file and decide something". Every one of those scripts starts as `curl -s` plus a variable.

## Going further

Right now you cannot tell a good answer from an error page, because you only looked at the body. In the next level you will ask curl for the HTTP status code as well.
