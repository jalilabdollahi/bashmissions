# Walkthrough: Plugin Loader

## The plan

A plugin system has one rule: the core discovers its extensions instead of
listing them. Here discovery is "every `*.sh` file in a folder", and
registration is "the file defines a function with an agreed name".

## Step by step

Check the folder first, so a typo gives a clear message:

```bash
dir=$1
if [[ ! -d $dir ]]; then
  echo "lf: plugin directory '$dir' not found" >&2
  exit 1
fi
```

Loop over the files. The glob `"$dir"/*.sh` is expanded by the shell in
alphabetical order, which makes the load order predictable. Keep the pattern
outside the quotes and the directory inside them, so odd directory names are safe:

```bash
for file in "$dir"/*.sh; do
```

Cut the plugin name out of the path with two expansions: `${file##*/}` removes
the longest prefix ending in `/`, and `${name%.sh}` removes the suffix:

```bash
  name=${file##*/}
  name=${name%.sh}
```

Now `source "$file"` runs the file in the current shell. That is the whole
trick: a function defined there is defined here, so afterwards `plugin_$name`
can be called as if it had always been in your script:

```bash
  source "$file"
  echo "loaded $name"
  "plugin_$name"
```

## The empty folder

If nothing matches, Bash leaves the pattern unexpanded and the loop runs once
with the text `plugins/*.sh`. Sourcing that fails. `shopt -s nullglob` before
the loop makes an unmatched pattern disappear. Then count the iterations and
print "no plugins found" if the counter stayed at zero.

## Try it by hand

```
mkdir -p plugins
echo 'plugin_demo() { echo hi from demo; }' > plugins/demo.sh
./solution.sh plugins
./solution.sh empty-folder-that-does-not-exist
```

## Alternative

You can skip `nullglob` and test `[[ -e $file ]] || continue` inside the loop.
That works too, but it silently skips a real file that disappears mid-run, and
the count of loaded plugins needs extra care. `nullglob` says what you mean.
