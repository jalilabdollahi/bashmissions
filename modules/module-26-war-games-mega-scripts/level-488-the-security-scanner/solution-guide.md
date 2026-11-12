# Walkthrough: The Security Scanner

## The plan
A scanner is a set of independent detectors that all write into one list of findings, followed by one reporting step. The detectors here are the classics: files anyone can overwrite, private keys that other users can read, setuid programs nobody approved, risky `sshd` settings, and passwords sitting in config files. Each finding gets a rank (1 critical, 2 high, 3 medium) when it is recorded. At the end, `sort` puts critical first, the rank is stripped, and the summary and exit status are computed once.

## Step by step

1. **Arguments.** Optional `--fail-on LEVEL`, then ROOT, then an optional allowlist. Validate all of them first and exit 2 on mistakes. Paths in findings are made relative with `${path#"$root"/}`, so the report does not depend on where the scan ran.

2. **Permission checks with `find`.** The easy-to-miss rule: `-perm -MODE` matches when *all* bits of MODE are set. `-perm -0002` ("others can write") is a single bit and works as expected. But "group or others have any access" is six bits joined with OR: `-perm -0040 -o -perm -0020 ...`. Using `-perm -0077` would miss a key that is merely group-readable (`0640`), the typical real-world mistake. Setuid and setgid are the bits `4000` and `2000`.

3. **Read loops without subshells.** `find ... | while read` would run the loop in a subshell and throw away the findings. `while read -r f; do ...; done < <(find ...)` keeps the loop in the current shell.

4. **sshd semantics.** The daemon uses the *first* occurrence of an option and ignores case. A scanner that reports the last value, or is case-sensitive, will disagree with the real daemon: it would warn about an option that is not in effect and miss one that is. So: lower-case the key, skip keys already seen, remember the value.

5. **Credentials.** Lower-case the line and match with one regex: a key containing `password`, `secret`, `token`... then `:` or `=`, then a capture group for the value. Placeholders (`${API_KEY}`, `<set me>`), empty values and comments are not findings. The report prints the file and line, never the value: a security tool that prints secrets into a log file has just created the problem it was meant to find.

6. **Report and exit.** Sort with `LC_ALL=C` so the order is the same on every machine. The exit threshold is a simple arithmetic test: for `high`, the number of critical plus high findings must be zero.

## Complete solution
The trickiest detector:
```bash
find "$root" -type f \( -name '*.key' -o -name id_rsa -o -name id_ed25519 -o -name id_ecdsa \) \
     \( -perm -0040 -o -perm -0020 -o -perm -0010 -o -perm -0004 -o -perm -0002 -o -perm -0001 \)
```

## Try it by hand
```bash
mkdir -p srv/home/theo/.ssh; echo k > srv/home/theo/.ssh/id_rsa; chmod 644 srv/home/theo/.ssh/id_rsa
./solution.sh srv; echo "exit $?"
chmod 600 srv/home/theo/.ssh/id_rsa; ./solution.sh srv
```

## Alternative
`find -perm /0077` (GNU) or `-perm +0077` (old BSD) means "any of these bits" in one test, but the two systems spell it differently, and the portable form is the explicit list.
