# Walkthrough: The Config Manager

## The plan
Every non-trivial program gets its settings from several places, and bugs live in the gaps: which one
won? The design here has four parts. A **schema** says which settings exist and what they may contain. A
fixed **layer order** says who wins. A **source** is remembered per key so any value can be explained.
**Validation** runs once, on the merged result, and reports every problem together.

## Step by step
1. **Arguments.** Options come first (`--layer`, `--set`, `--prefix`, `--reveal`), then the schema file and the
   command. The command word decides how many extra arguments are legal; everything else is usage, exit 2, as is
   an unreadable file.

2. **Schema.** `IFS='|' read -r key type default flags _` fills `type_of`, `default_of` and `flags_of`, an ordered
   `keys` array, and seeds `value[$key]` with the default and `source[$key]` with `default`. Because the seed is
   the lowest layer, "default" needs no special case later.

3. **Files.** Each layer is read line by line: trim, skip comments, split at the first `=` (so values may contain
   `=`), trim both sides, strip one pair of quotes. Keys not in the schema are errors with `FILE:LINE`, which is
   what catches typos like `db.hots`. The test `[[ -n ${type_of[$k]+set} ]]` is true for any defined key, even
   one whose value is an empty string.

4. **Environment.** The variable name is computed: prefix, underscore, key with dots turned into underscores,
   upper-cased. `[[ -v $name ]]` asks "is that variable set?" and `${!name}` reads it through the name
   (indirect expansion). An *empty but set* variable counts: that is how an operator deliberately blanks a setting.

5. **`--set`.** The top layer. It is validated like a file line, with its own messages.

6. **Validate once.** Walk the keys in schema order. Empty values are fine unless `required`. Types are
   checked with a regex or arithmetic; booleans are *normalised* to `true`/`false` so every consumer sees one
   spelling. Collecting messages in an array and printing them all, then exiting 1, means a broken config gets
   fixed in one round trip instead of five.

7. **Commands.** `show` and `get` go through one `shown` function that masks secrets; exports skip them unless
   `--reveal`. The three export formats differ only in quoting: none for `env`, single quotes (with the `'\''`
   trick) for `shell`, escaped double quotes and unquoted numbers/booleans for JSON.

## Try it by hand
```
APP_DB_PORT=6543 ./solution.sh --layer conf/defaults.conf --layer conf/prod.conf schema.txt show
./solution.sh --layer conf/defaults.conf schema.txt export json
```

## Alternative
Validating each layer separately seems tidier but is wrong: `db.port = 99999` in a base file may be overridden by
a good value on top, and a required key may be supplied only by the environment. Only the merged value matters.
