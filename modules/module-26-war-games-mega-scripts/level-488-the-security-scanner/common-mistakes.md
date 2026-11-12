# Common Mistakes

- **`-perm -0077` for "group or others have access".** That requires all six bits. A key with mode `0640` slips through. List the six single-bit tests with `-o`.
- **`find | while read` and a findings array.** The loop runs in a subshell; the array is empty afterwards. Use `done < <(find ...)`.
- **Reading the last `sshd_config` value.** sshd honours the first. A file with `PermitRootLogin no` followed later by `yes` is safe; reporting it is a false alarm, and the reverse order is a real hole.
- **Case-sensitive keys.** `permitrootlogin yes` is exactly as valid as `PermitRootLogin yes`. Lower-case before comparing.
- **Printing the secret.** `plaintext credential: password=hunter2` copies the secret into the scan log. Report the file and line number only.
- **Following symlinks.** Without `-type f`, a symlink to `/etc/shadow` inside the tree is reported (or worse, read). Restrict the checks to regular files.
