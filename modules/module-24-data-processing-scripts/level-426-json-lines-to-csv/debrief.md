# Debrief: JSON Lines to CSV

The mental model: **you can parse a restricted format with text tools if you
state the restrictions.** Full JSON is nested and has a grammar a regular
expression cannot follow. JSON Lines with flat objects and a known list of keys
is a much smaller language: find the key, look at one character, read to a
known terminator. The skill is in writing down what you assume (flat objects,
four keys, only `\"` and `\\` escapes) and making the script honest about
it, rather than pretending to be a general parser.

Notice how the first character of a value decides everything: a quote means a
string that ends at the next unescaped quote, anything else is a bare token.
That is exactly how real parsers start, one character of look-ahead deciding
the branch. The backslash handling is a small state machine: after `\`,
the next character is data, not syntax.

The output side has its own rules. CSV quoting is the mirror image of the escape
work in the previous level: the same value needs different treatment in each
format. Quote only when needed (a comma or a quote inside), and double the
quotes.

JSON Lines is everywhere in logging (shippers, cloud audit logs, API exports)
because each line is independent and can be streamed. That also makes it ideal
for line-oriented tools like awk.

Going further: logs are not always JSON. The next level reads the oldest and
most common web log format, where a request line hides inside quotes.
