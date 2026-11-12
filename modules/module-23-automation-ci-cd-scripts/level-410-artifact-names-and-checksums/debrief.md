# Debrief: Artifact Names and Checksums

The mental model: **an artifact is only useful if it identifies and verifies
itself.** The name answers "what is this?" (product, version, platform); the
manifest answers "is it intact?". Both are produced from the same script so they
can never disagree, because the manifest is generated *after* the final names
exist.

Two habits make release scripts trustworthy. First, idempotence: running it
again must give the same result, so already-renamed files are recognised and
skipped. Second, atomic publication: write the manifest under a temporary name
and `mv` it into place, because a rename within one directory happens in one
step. A consumer can then never read a truncated list.

On checksums: `cksum` is a CRC, which catches accidental corruption (a cut-off
download) but not tampering. Real releases use SHA-256 for that and often sign
the manifest. The portable choice here is deliberate: the file format
(`hash size name`) is what matters, and swapping the tool is a one-word change.

Also notice `nullglob`: an unmatched glob normally survives as literal text, which
is one of Bash's classic surprises.

Going further: artifacts often ship inside container images. The next level
builds and tags an image through the `docker` command line.
