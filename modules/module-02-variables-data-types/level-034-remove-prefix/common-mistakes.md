# Common Mistakes for Remove Prefix

- Confusing `#` with `##`: single is *shortest* match, double is *longest*. Easy to get backwards.

- Treating the pattern as a regex. `${var#.*}` matches a literal dot followed by any characters — but the `.` is literal, not "any char". For "any char", use `?` (single) or `*` (any number).

- Forgetting that `*` is greedy in the longest-match form. `${path##*/}` strips up to the **last** `/`, leaving just the basename.

- Trying to anchor like a regex. The patterns are implicitly anchored: `#` is start, `%` is end. There's no `^` or `$`.

- Using on the wrong side. `${var#.tar.gz}` does nothing for `report.tar.gz` because the prefix doesn't match. Use `${var%.tar.gz}` (suffix) or `${var#*.}`.
