# Walkthrough: Incident Snapshot

## The plan

An incident snapshot is a small forensic kit: gather the volatile facts first,
protect them, and make tampering detectable. Every step follows from that.

## Building it

Start by refusing to continue if the folder already exists. Incident folders
are named after the time and host, so an existing one means someone is already
working on it, and overwriting it would destroy their evidence.

Create the folder with `mkdir -m 700`. Evidence can contain command lines,
usernames and connection details, so it should be private from the first
instant; creating it with the default mode and fixing it afterwards leaves a
window.

Write a `collect FILE COMMAND...` function: the first argument names the file,
`shift` drops it, and `"$*"` is the remote command. Four calls then gather the
evidence in order. Inside, run the command with `ssh -n -o BatchMode=yes`, redirecting stdout and stderr
to the file, and capture the exit status with `|| rc=$?`. Three outcomes:
success; a non-zero status below 255, where the error text is already in the
file and you append `ERROR: exit N`; or 255, where the host cannot be reached
and no evidence exists, so you remove the folder and stop.

Then `meta.txt` records who collected what and when. The last step is the
seal: from inside the folder run `cksum` over the five files, sorted by name.
Running inside the folder gives bare names, and listing the files explicitly
keeps `MANIFEST` out of its own list.

## Complete solution

See answer.sh.

## Trying it by hand

```
./solution.sh anchovy 20260301-0930
ls -l incident-20260301-0930-anchovy; cat incident-*/MANIFEST
```

## Alternative

You could pack everything into a tarball. A plain folder with a manifest is
easier to inspect and to verify with the manifest checker you wrote earlier.
