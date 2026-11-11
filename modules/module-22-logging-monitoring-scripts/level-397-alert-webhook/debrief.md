# Debrief: Alert Webhook

An alert is only worth something if it arrives, so the interesting part of
this level is not sending: it is checking *what happened* when you sent. HTTP
gives every reply a three-digit status: 2xx means accepted, 4xx means you
did something wrong (bad URL, bad payload), 5xx means the server is in
trouble, and `000` is curl's way of saying that nothing answered at all. Your
script treats only 2xx as delivery, and everything else as a failure that must be
visible on stderr and in the exit status.

The curl flags are a vocabulary worth memorising: `-sS` (quiet but honest),
`-X POST` and `-H` and `-d` (what to send), `-o /dev/null` (do not show me the
reply), `-w '%{http_code}'` (tell me just the status), `--max-time` (never wait
forever, a hung alert is worse than a failed one).

The other lesson is about **building data with strings**. JSON is text with
rules; when a value comes from outside, escape it *before* you wrap it in
quotes, or one stray `"` turns your alert into a parse error (or lets someone
inject fields). Real scripts reach for `jq` when it is available; knowing the
manual escape order (backslash first) shows you what the tool does for you.

Keep the secret URL in the environment, never in the script.

Going further: alerts and logs are evidence. The next level makes a log whose
lines cannot be quietly changed afterwards.
