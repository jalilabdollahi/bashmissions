# Walkthrough: Define and Call

## The plan
The report has three identical ruler lines and two lines of text. We write the
ruler once as a function, then use it like a command.

## Building it
A function definition is a name, `()` and a body in curly braces:

```bash
rule() {
  echo "========================"
}
```

Nothing is printed yet. Bash only remembers the name. The body runs each time
you write `rule` as a command:

```bash
rule
echo "Nightly report: $TITLE"
rule
```

Order matters: Bash reads the file from top to bottom, so the definition has to
come before the first call.

## Complete solution
```bash
#!/usr/bin/env bash
rule() {
  echo "========================"
}
rule
echo "Nightly report: $TITLE"
rule
echo "All servers reporting."
rule
```

## Try it by hand
```bash
TITLE="Harbour Bakery" ./solution.sh
```
Change the number of equals signs inside the function and notice that all three
rulers change together. That is the whole point.

## Alternative
You could write `function rule { ...; }` (the `function` keyword, no
parentheses). It works in Bash, but `name() { ...; }` is the form that also works
in other shells, so it is the one used throughout this course.
