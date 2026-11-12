# Debrief: POST Form Data

## What you learned

A request is more than a URL. It has a **method** (what you want done), headers, and optionally a **body** (the data you send). GET asks for something; POST gives the server something to process: a signup, an order, a comment. In curl, `-d "a=1&b=2"` supplies the body and switches the method to POST on its own.

## Under the hood

The wire format of a classic web form is plain text: `name=value` pairs joined by `&`. curl adds a `Content-Type: application/x-www-form-urlencoded` header so the server knows how to read the body. Special characters inside values (a space, `&`, `=`) must be percent-encoded; ordinary addresses and plan names are safe as they are, but remember the rule when the data comes from users.

Notice that the server answered with a normal body even for the unknown plan, and curl exited 0. HTTP errors are data, not failures of curl. You already met that idea with status codes, and the next levels build on it.

## In real work

Webhooks, login forms, "create a ticket" endpoints and signup pages all accept form posts. A script that can POST can automate any of them.

## Going further

Modern APIs rarely speak form encoding. They want JSON and a header that says so. That is the next level.
