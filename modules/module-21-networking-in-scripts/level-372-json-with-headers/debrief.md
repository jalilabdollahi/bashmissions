# Debrief: JSON with Headers

## What you learned

Headers are the metadata of a request. `Content-Type` says how to read the body; without it the server must guess, and well-behaved APIs refuse to. JSON is just text with strict rules: strings in double quotes, numbers bare, no trailing commas.

## Under the hood

curl sends `-d` bodies as `application/x-www-form-urlencoded` unless you say otherwise. The stub in your workspace logs the headers it was given, so open `.calls.log` after a run and you can see the header travel with the request. `-H` may be repeated; later levels will add `Authorization` and `Accept` headers the same way.

Building JSON by pasting variables into a string is fine for tiny payloads, but only if you validate: one stray `"` in a customer name changes the structure of the document. Treat every value as untrusted until you have checked it. That is the same lesson as quoting in the shell: data must not be able to rewrite the code around it.

## In real work

Almost every modern API (billing, DNS providers, chat webhooks, cloud control planes) takes JSON and demands the content type. This request shape, `curl -H ... -d '{...}'`, is the one you will paste most often.

## Going further

Many of these APIs also want proof of who you are. In the next level the proof is a token, and the hard part is keeping it secret.
