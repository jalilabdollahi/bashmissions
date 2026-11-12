# Debrief: CSV to JSON

The mental model: **converting formats is a translation of rules, not a
substitution of characters.** CSV has one rule (commas separate, newlines end
the row) and no types. JSON has types (null, number, string) and its own
escaping. A converter's job is to decide each value's type and then apply the
target's rules to it. Gluing quotes around text only works until the first value
that contains the target's special characters.

Escaping has a classic ordering trap. If you escape quotes first and backslashes
second, the backslashes you just added get doubled; if you do it in the other
order it works, but only by luck of ordering. Processing the string one
character at a time removes the problem entirely: every input character
produces its output exactly once. That is the same idea as a real tokenizer and
it behaves identically in every awk.

Typing rules matter just as much. JSON numbers cannot start with a zero, so a
product code like `007` must stay a string or it will be rewritten as 7 by the
first consumer that parses it. When in doubt, quote.

Finally the structure: lists need commas between items, not after them.
Holding one item back and printing it late is the lightweight way to do that
without knowing the count in advance.

Going further: the next level goes the other way, extracting simple fields from
JSON Lines back into CSV, where quoting a CSV field is the new puzzle.
