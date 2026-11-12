# Walkthrough: Single Quotes Are Literal

## The plan
The text contains dollar signs that must reach the screen untouched. In Bash, `$name` means "insert the value of the variable called name". Double quotes allow that insertion, single quotes forbid it.

## Step by step
1. Run the starter. The output has a real path where `$HOME` should be, and `$5` vanishes: Bash treats `$5` as "the fifth argument", which is empty.
2. Replace the double quotes with single quotes on both lines.
3. Run again and compare against the objective.

## Complete solution

```bash
#!/usr/bin/env bash
echo 'Never paste $HOME or $USER into a ticket.'
echo 'Late report fee: $5 per day.'
```

## Trying it by hand
In the terminal try both:

```
echo "my home is $HOME"
echo 'my home is $HOME'
```

## An alternative
You could keep double quotes and escape every dollar with a backslash: `echo "Late report fee: \$5 per day."`. It works, but with many dollars it gets noisy. Single quotes are the cleaner tool when you want text taken literally. The catch: a single quote cannot appear inside single quotes.
