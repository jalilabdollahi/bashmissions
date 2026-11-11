# Debrief: Extract with grep -o

By default grep is a *line selector*: if a line matches, you get the whole line.
`-o` turns it into a **text extractor**: it prints only the part that matched,
and if a line contains several matches, each one gets its own output line.
Suddenly a haystack of sentences becomes a clean list of needles.

This is the usual recipe for turning unstructured logs into data:

```
grep -oE '<shape of the thing>' file | sort | uniq -c
```

The shape is a regex, the extraction is `-o`, and the pipeline does the
bookkeeping. You can use it for addresses, ticket numbers, email addresses,
hostnames, anything you can describe.

Notice the repeated group `([0-9]{1,3}\.){3}`. Quantifiers apply to groups too, so
"n-dot, three times" is one compact phrase instead of three copies of the
same text. The regex also shows you the limit of its own method: it finds
anything that *looks* like an address, including `999.1.1.1`. Extraction finds
candidates; validation (as in level 223) decides which ones are real.

The shell detail to remember is `pipefail`. A pipeline reports a failure if any
stage fails, and grep's "no match" counts as a failure, so decide on purpose
whether an empty result is an error. Here it is not.

Going further: besides finding lines, grep can count them and select their
opposite. That is the next level.
