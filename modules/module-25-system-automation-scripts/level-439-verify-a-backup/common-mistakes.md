# Common Mistakes

- **Using `cksum file` and comparing with the manifest's three fields.** The output contains the path too, which differs from the bare name in the manifest.
  - Right: `cksum < "$dir/$name"` gives only `CRC SIZE`.
- **Comparing only the CRC.** A truncated or padded file can keep the CRC by accident less often than people think, but the size check is free.
  - Right: compare `"$crc $size"`.
- **Forgetting that a missing file makes `cksum` fail.** Under `set -e` the script dies on the first lost file and never reports the rest.
  - Right: test `[[ -f $dir/$name ]]` first and say MISSING.
- **Listing MANIFEST itself as UNLISTED.** The manifest cannot checksum itself.
  - Right: skip it by name in the second pass.
- **Exiting 0 after printing FAILED.** A cron job only notices problems through the exit status.
  - Right: end with a command that fails when `failed` or `missing` is non-zero.
