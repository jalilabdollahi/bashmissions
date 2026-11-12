# Common Mistakes

- **Comparing versions as text.** Wrong: `[[ 1.9.0 > 1.10.0 ]]` is true, because `9` sorts after `1`. Right: split on dots and compare each part with `(( ))`.
- **Recording before deploying.** Wrong: writing `versions/staging` first, so a failed deploy leaves a record of something that never ran. Right: update the file only after `deployctl` succeeded.
- **Allowing a skip by checking names only.** Wrong: accepting any two valid stage names, so `dev prod` works. Right: require `to_i == from_i + 1`.
- **A bare `read` of a missing file.** Wrong: `version=$(<versions/dev)` aborts the script with a raw shell error. Right: test `-r` first and answer with the level's own message.
- **Treating approvals as a flag you can pass.** Wrong: `--approved` as an argument anyone can type. Right: an approval file that a different person creates.
