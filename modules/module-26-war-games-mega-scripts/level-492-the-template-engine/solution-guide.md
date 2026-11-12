# Walkthrough: The Template Engine

## The plan
A template engine is a small interpreter. The "program" is the template, the "memory" is the variables, and the output is whatever the program prints. Ours has three features: substitution, conditionals and loops. Conditionals and loops are *blocks* that can nest, so we need two phases: first understand the block structure of the template, then execute it.

Safety rules shape the design. Templates are data, so `eval` is out: a template line like `{{x}}; rm -rf ~` must be text, not code. And a half-rendered config is worse than none, so nothing is printed until the whole render succeeded.

## Step by step

1. **Variables.** `NAME=VALUE` lines go into an associative array, splitting at the *first* `=` with a regex so values may contain `=`. Command-line `-D` options are applied afterwards, so they override the file. That precedence (file < command line) is the convention everywhere.

2. **Classify lines.** A regex recognises `{% ... %}` lines. The first word of the directive decides what it is. Everything else is `text`. Directive lines are marked so that they print nothing.

3. **Pair blocks with a stack.** `if` and `for` push their line index. `endif` / `endfor` must find the matching kind on top of the stack; they record `end_of[opener]=closer` and pop. `else` records `else_of[opener]`. Mismatches become errors with the line number; whatever remains on the stack at the end is "unclosed" at its opening line. All structural errors are collected, sorted by line, and printed together.

4. **Render recursively.** `render START END` walks a range of lines. For text it replaces placeholders and appends to the buffer. For an `if` it evaluates the condition and recurses into the then-range or the else-range; the ranges come straight from `else_of` and `end_of`. For a `for` it recurses once per item. Because each call gets its own range, nesting needs no special code.

5. **Placeholders without `eval` or `sed`.** Peel the string with parameter expansion: text before `{{`, the expression up to `}}`, and so on. Split `name:-fallback` with `${expr%%:-*}` and `${expr#*:-}`. The difference between *unset* and *empty* matters: an empty value is legal (and triggers the fallback if there is one); an unset one with no fallback is an error. `[[ -z ${vars[$name]+set} ]]` tests "unset".

6. **Scope.** A loop sets the item variable and `loop.index` for its body. Before it starts, save the old values and whether they existed; after it ends, restore them. Without that, the inner loop's `loop.index` would leak out and the outer loop's trailer would print the wrong number.

## Complete solution
The loop case is the subtle one:
```bash
had_idx=${vars[loop.index]+set}; saved_idx=${vars[loop.index]:-}
for item in "${list[@]}"; do
  idx=$((idx + 1)); vars[$item_var]=$item; vars[loop.index]=$idx
  render $((j + 1)) "$end_j" || return 1
done
if [[ -n $had_idx ]]; then vars[loop.index]=$saved_idx; else unset 'vars[loop.index]'; fi
```

## Try it by hand
```bash
./solution.sh fixtures/site.tpl fixtures/site.vars
./solution.sh -D tls=no -D backends=dory fixtures/site.tpl fixtures/site.vars
```

## Alternative
`envsubst` replaces `$VAR` only: no conditions, no loops, and unset variables silently become empty. Using `sed` per variable is quick but breaks on values containing `/` or `&`. For serious templates people reach for Jinja or Go templates; the structure of those engines is what you just built.
