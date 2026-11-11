# Debrief: printf Placeholders

printf separates the shape of a line from the data that goes in it. That is a mental model you will use in every language: a template plus values.

## How it works
Printf reads the first argument as the format. Wherever it meets a `%` conversion it takes the next value from the remaining arguments. `%s` prints the value as text, `%d` converts it as a whole number. If you give `%d` something that is not a number, printf complains instead of silently printing nonsense, which makes mistakes visible.

If there are more values than placeholders, printf reuses the format for the rest. That is handy later, when you print a list.

## In real work
Reports, log lines and status messages are all templates with values. Keeping the template in one place makes a script easy to read and change.

## Going further
Next, you will make the columns line up by giving each placeholder a width.
