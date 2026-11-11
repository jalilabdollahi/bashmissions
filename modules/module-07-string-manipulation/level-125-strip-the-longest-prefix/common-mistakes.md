# Common Mistakes

- **Single hash for the file name.** `${path#*/}` removes only the first slash
  and everything before it: `/var/log/error.log` becomes `var/log/error.log`.
  Use `##`.
- **Forgetting the star.** `${path##/}` only removes a prefix that is exactly
  `/`. Right: `${path##*/}`.
- **Unquoted loop list.** `for path in $@` splits `/srv/tidewater books/Q3
  report.pdf` into pieces. Always write `"$@"`.
- **Trusting a trailing slash.** `${path##*/}` of `/var/backups/` is empty, not
  `backups`. If that matters, strip the trailing slash first.
