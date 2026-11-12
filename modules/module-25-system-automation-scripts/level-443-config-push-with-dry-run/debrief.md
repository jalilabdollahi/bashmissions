# Debrief: Config Push with Dry-Run

## What you learned

Any command that changes many machines deserves two modes: preview and apply. The loop and the formatting are identical, only the verb changes. A good preview prints precisely the commands or targets the real run would use, so reading it is a genuine review.

## Under the hood

scp names a remote file as `host:path`; everything before the first colon is the host. It exits 0 only if the transfer finished, which makes `if scp ...` a reliable test. `-q` hides the progress meter that clutters logs, and `BatchMode=yes` prevents password prompts, as in the previous level.

`-s` versus `-e`: `-e` only asks "is there a file?", while `-s` asks "is there something in it?". Many outages are a deploy of a file that existed but was empty or truncated.

## In real work

Mature teams push configuration in stages (one canary host, then a batch) and validate the file with the service's own syntax checker (`nginx -t`, `sshd -t`) before and after. A copy that lands in a temporary name and is moved into place atomically avoids hosts reading half-written files.

## Going further

Dates matter next: you will read certificate expiry dates and work out how many days are left.
