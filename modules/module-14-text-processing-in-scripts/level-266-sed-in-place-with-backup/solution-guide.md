# Walkthrough: sed In Place with Backup

## The plan
Substituting is old news; the new idea is changing the file itself instead of
printing a modified copy, without losing the original. sed's `-i` does the
first, and a suffix glued to it does the second.

## Step by step
1. Give the arguments names: `old=$1 new=$2 file=$3`. Scripts read better and
   it avoids mixing up `$2` and `$3` in the middle of a long command.

2. Write the substitution as `s/old/new/g`. The `g` flag replaces all matches
   on each line instead of the first only. Because the program contains
   variables, wrap it in double quotes: `"s/$old/$new/g"`.

3. Make it in place with a backup:

   ```bash
   sed -i.bak "s/$old/$new/g" "$file"
   ```

   sed reads `$file`, writes the edited text to a temporary file, saves the
   original as `$file.bak`, and puts the new version in place.

4. Why the suffix is not optional. GNU sed (Linux) allows `-i` alone and treats
   an attached suffix as optional. BSD sed (macOS) requires an argument after
   `-i`, so `sed -i 's/a/b/' f` takes `s/a/b/` as the suffix and fails. Writing
   `-i.bak`, with the suffix glued on, means the same thing on both. A free bonus
   is a rollback copy.

5. Print the confirmation: `echo "patched $file"`.

## Complete solution
```bash
#!/usr/bin/env bash
set -euo pipefail
old=$1 new=$2 file=$3
sed -i.bak "s/$old/$new/g" "$file"
echo "patched $file"
```

## Try it by hand
```bash
printf 'server anchovy\n' > t.conf
./solution.sh anchovy flounder t.conf
cat t.conf t.conf.bak              # new, then old
mv t.conf.bak t.conf               # rollback
```

## Alternative
Without `-i`, you would write `sed ... f > f.new && mv f.new f`, which is
what sed does itself, minus the backup. Never use `sed ... f > f`: the shell
truncates the file before sed reads it, and you lose everything.
