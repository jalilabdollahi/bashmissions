# Debrief: Log Archiver

## What you learned

Housekeeping scripts are dangerous precisely because they delete things. The pattern you used, write to a temporary name, verify, rename, then remove the source, is the same one databases, package managers and editors use to avoid losing data when something crashes halfway.

## Under the hood

`find -mtime +N` compares the file's modification time with now, counted in whole 24-hour periods, and rounds down: `+30` means 31 days or more. `gzip -c` writes the compressed stream to stdout, which lets you choose the destination name yourself. A rename inside one filesystem is atomic: other programs see either the old state or the new one, never a half file. The `.partial` suffix is a convention that tells humans and later runs "unfinished".

Looping with `< <(find ...)` instead of `find | while` keeps the loop in the current shell, so counters survive.

## In real work

`logrotate` does all of this and more, and you should use it for services. Scripts like yours are for the logs `logrotate` does not know about: application dumps, vendor tools, report folders.

## Going further

Archiving keeps data. The next level is about deciding what may be deleted outright, with rules for age and size.
