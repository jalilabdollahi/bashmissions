# Common Mistakes

- **Looping over an unmatched glob.** Wrong: `for f in dist/*.tar` with no tars runs once with the literal text `dist/*.tar`, so `mv` fails oddly. Right: `shopt -s nullglob`, collect into an array, check its length.
- **Renaming twice.** Wrong: a second run produces `app-1.0.0-app-1.0.0-linux.tar`. Right: skip names that already start with the prefix.
- **Directories inside the manifest.** Wrong: `cksum dist/*.tar` writes `dist/linux.tar` and nobody can verify from inside the download folder. Right: `cd dist` first (in a subshell).
- **Listing the manifest in itself.** Wrong: `cksum *` includes the previous `MANIFEST.txt`. Right: glob only `*.tar`.
- **Machine-specific hashing.** Wrong: `sha256sum` fails on macOS, `shasum -a 256` on minimal Linux. Right: use `cksum` here, or detect the tool before calling it.
