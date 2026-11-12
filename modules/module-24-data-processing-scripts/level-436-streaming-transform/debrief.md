# Debrief: Streaming Transform

The mental model: **a stream is a conveyor belt, not a warehouse.** A streaming
program looks at one item, does its job, passes it on, and keeps only a small
summary of what it has seen. Memory use depends on the *state*, not on the *size
of the input*. That is why `grep`, `awk`, `sed` and `cut` can process files
larger than RAM, and why a pipeline can start printing before its first stage
has finished.

You can read a design for streaming by asking two questions. What does the
program remember between lines? (Here: running total and two counters; a
`sort`, a "dedupe by key" or an array of rows would grow without bound.) And
when does the first output appear? (Immediately here; after the whole input for
`sort`.) Operations that need the full picture (sorting, ranking, joins on
unsorted data) are not streams; they are earlier levels of this module, and the
skill is knowing which kind of job you have.

The "no temporary files" rule follows from the same idea. A temp file is a
warehouse on disk: it can fill the disk, it must be cleaned up, and it breaks
when the script is killed. A pipe is a small kernel buffer, and a fast producer
simply waits for a slow consumer.

Integer cents are the money lesson of this level: represent exactly, format at
the edge. Floating point arithmetic is for measurements, not ledgers.

Going further: you have finished the data-wrangling module. The next module
turns from files to the system itself: filesystems, permissions and archives.
