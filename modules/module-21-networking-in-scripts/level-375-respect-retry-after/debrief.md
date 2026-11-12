# Debrief: Respect Retry-After

## What you learned

A response is a status line, **headers**, and a body. Headers carry the instructions around the data: how long to wait, what type the body is, where to go next. `Retry-After` is the server's polite request to back off, and a good client obeys it instead of guessing.

## Under the hood

`curl -D file` saves the header block. Each line is `Name: value` terminated by carriage return plus newline (`\r\n`); that invisible `\r` is the reason a naive `$(...)` comparison fails. Names are case-insensitive by specification, and HTTP/2 even requires lowercase, so match them with `grep -i`.

Retrying needs three safeguards, all in this script: a **limit** on attempts, a **delay** (taken from the server when it tells you), and a **different reaction** for errors that retrying will never fix. A 404 will still be a 404 in three seconds.

The test setup replaced `sleep` with a recorder. Doing the same in your own scripts, by making the delay a variable you can override, is a neat way to test retry logic without waiting.

## In real work

GitHub, cloud providers, payment gateways and every large API answer with 429 and `Retry-After` or similar headers. Respecting them is the difference between a script that works for years and one that gets its IP banned.

## Going further

The replies so far were plain text. Next you will pull one value out of a JSON reply, with nothing more than `sed`.
