# Debrief: Rate-Limited Calls

## What you learned

Servers protect themselves with **rate limits**, and a polite client stays under the limit instead of waiting to be told off. In the retry level you reacted to a 429; here you prevented it by pacing. The tools are a counter, the `%` operator and `sleep`.

## Under the hood

`sent % 2 == 0` is true on requests 2, 4, 6 and so on, which makes a cheap "every Nth" test. The extra `remaining > 0` check matters in real scripts: every needless sleep adds up, and an exit path that waits is annoying in a cron job and in a deploy.

This pacing is crude. It allows a burst of two requests at once, then a second of silence, which is within the limit as stated but is not perfectly smooth. Real clients sometimes track timestamps or use a token-bucket scheme. For a list of a few hundred IDs the simple approach is plenty, and obvious code is a feature.

Failures must count too. If a failing call did not increase the counter, a run of 404s would hammer the server faster than allowed. The test stub for `sleep` writes the pause to a log instead of waiting, a trick worth reusing whenever you test code that spends time.

## In real work

Bulk exports from SaaS APIs, bulk DNS changes, mass notifications: all of them are loops with a speed limit. The combination "retry on 429, pace to avoid it" is what a robust API client does.

## Going further

For the final level you will combine status codes, ports and exit statuses into a single probe report.
