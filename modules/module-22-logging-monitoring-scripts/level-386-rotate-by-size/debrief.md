# Debrief: Rotate by Size

Logs only ever grow, and a disk only ever has so much room. Rotation is the
standard answer: keep a fixed number of old files and let the oldest go. The
total space used becomes a number you chose (roughly MAXBYTES times KEEP+1)
instead of a number you discover during an outage.

Two mental models are packed into this script. First, **measure before you
act**: `wc -c` counts bytes from a stream, so the file name never appears in
the output, which is why you feed it with `<`. Second, **order of operations on
a shared namespace**: renaming into a name that already exists destroys what was
there, so you free the highest slot first and work back toward the start. The
same reasoning applies to shifting array elements or reordering database rows.

Renaming is also cheap and atomic: the file's data does not move, only its
name. A service that still has the old file open keeps writing to what is now
`.1` until it reopens its log, which is why real tools such as `logrotate`
often send a signal afterwards. Creating the new empty file in the same step
means that nothing is ever without a log file to write to.

You will find this in cron-driven housekeeping on every server, and
`logrotate` is this script with many more options.

Going further: the next level changes *what* goes into the log lines, so that
machines can read them as easily as humans.
