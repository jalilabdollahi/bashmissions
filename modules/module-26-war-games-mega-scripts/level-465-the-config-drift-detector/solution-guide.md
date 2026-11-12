# Walkthrough: The Config Drift Detector

## The plan
Drift detection is a comparison with opinions. `diff -r` tells you that two files differ; an
operator wants to know whether the *settings* differ. So the script compares meaning: for config
files, the set of `KEY=VALUE` pairs after stripping noise; for everything else, the checksum; and
for sensitive files, the permissions. Findings are collected per path, so the report and the
`--plan` output come from the same classification code.

## Step by step
1. **Arguments and control files.** `--plan` is optional; two directories are required. `.modes`
   goes into an associative array (`want_mode[path]=octal`), `.ignore` becomes a space-separated
   string. Both are *control* files and are excluded from the compared paths.

2. **One merged path list.** Run `find . -type f` in both trees (with `cd` in a subshell so the
   leading `./` is easy to strip), concatenate, `sort -u`. Every path is then exactly one of:
   golden only (MISSING), live only (UNMANAGED) or both (compare).

3. **Normalising `.conf` files.** One awk invocation reads both files. `FNR == NR` is true only
   for the first file, so it fills `g[]` for golden and `l[]` for live. Comment lines and lines
   without `=` are skipped, keys and values are trimmed, a value in double quotes loses them, and
   ignored keys are dropped before they are ever stored. The `END` block walks the union of keys
   and prints `key|line`; the shell sorts on the key and cuts it off. Because `g[k]` is overwritten
   by later duplicates, "last wins" costs nothing.

4. **Masking.** Show `***` for any key whose lowercase name contains `pass`, `secret`, `token` or
   `key`. The comparison still uses the real values, only the display is masked, so a changed
   password is reported without leaking either one.

5. **Other files and modes.** `cksum < file` on both sides, compared as text. Permissions come
   from `ls -l`: characters 2-10 are three `rwx` triples, each converted by adding 4, 2 and 1.
   `x`, `s` and `t` all mean "executable" for that triple.

6. **Report or plan.** The same loop either prints the stanza (`DRIFT path` plus indented lines) or
   appends commands to an array: `cp` for content or missing files (with `mkdir -p` for new
   directories), `chmod` for wrong modes, a comment for unmanaged files. The tool *prints* the
   plan and never runs it: remediation on production deserves a human's eyes.

7. **Exit status.** Zero only when there is no drift, no missing and no unmanaged file.

## Try it by hand
```
./solution.sh golden live
./solution.sh --plan golden live
```

## Alternative
`diff -r` plus `grep -v '^#'` is the quick approach and works for a one-off look. It fails the
moment someone reorders keys or the reload timestamp changes, which is precisely when you need
the report to stay quiet.
