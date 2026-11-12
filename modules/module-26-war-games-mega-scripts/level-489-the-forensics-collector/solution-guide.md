# Walkthrough: The Forensics Collector

## The plan
Digital forensics has two golden rules: **do not change the evidence**, and **be able to prove you did not**. The first rule translates into copying (never moving), locking the copies read-only, and refusing to reuse a case folder. The second rule is a fingerprint per file, a list of those fingerprints (the manifest), a fingerprint of that list (the seal) and a log of who did what and when. Later, `verify` recomputes everything and reports any difference.

Time is passed in as `NOW`, as in earlier missions, so that the custody log is reproducible.

## Step by step

1. **Refuse to overwrite.** `[[ -e $case ]]` is checked before any work. Evidence folders are write-once; the first collection of a night must never be silently replaced by the second.

2. **Filter the sources first.** Only regular files count: not folders, not symlinks (a symlink could be repointed later), not missing files. Skipped ones are reported but do not stop the run. If nothing is left the case folder is not created at all, so a typo does not leave an empty case that looks official.

3. **Copy and prove the copy.** `cp -p` keeps the timestamps, which are themselves evidence. The copy gets a number-prefixed name (`printf -v name '%03d-%s'`) so two files called `syslog` from different directories cannot collide. Then `cksum` is computed on source and copy and compared. A mismatch (disk error, a file still being written) stops the collection with exit 3, because a manifest of fingerprints that were never true is worse than none.

4. **Lock.** `chmod 0444` on each copy, after the copy and the comparison, because you cannot copy over a read-only file and you do not want to change it afterwards.

5. **Manifest and seal.** One line per file: name, CRC, size, original path. The path is last, so `read -r name sum size orig` captures even paths with spaces. The seal is the `cksum` of the whole manifest, stored separately. Anyone editing the manifest to match doctored evidence also has to forge the seal, and the seal is also noted in the command's output (and, in real life, written on paper or mailed).

6. **Verify.** Order of checks per file: missing, modified, writable, ok. A file that is intact but writable is a finding too: it *could* have been changed between collection and now. Files that exist in `evidence/` but not in the manifest are `EXTRA`: planted evidence. Each run appends to the custody log whether it passed, and the exit status says the same to the caller.

## Complete solution
The core of the copy step:
```bash
cp -p "$src" "$case_dir/evidence/$name"
read -r sum size < <(cksum < "$src")
[[ "$(cksum < "$case_dir/evidence/$name")" == "$sum $size" ]] || exit 3
chmod 0444 "$case_dir/evidence/$name"
```

## Try it by hand
```bash
mkdir incident; echo hello > incident/a.log
./solution.sh collect case mara 1700000000 incident/a.log
./solution.sh verify case priya 1700000100
chmod 644 case/evidence/001-a.log; echo tampered >> case/evidence/001-a.log
./solution.sh verify case priya 1700000200
```

## Alternative
A cryptographic hash (SHA-256) would be required in real casework, because CRCs are easy to forge on purpose. `cksum` is chosen here only because it is on every system; the structure (manifest, seal, custody log) is identical with a stronger hash.
