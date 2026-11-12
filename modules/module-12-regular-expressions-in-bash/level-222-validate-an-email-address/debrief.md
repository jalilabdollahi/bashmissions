# Debrief: Validate an Email Address

This is the first time all the pieces meet: classes say *what*, quantifiers say
*how many*, anchors say *where*, and escapes say "I really mean a dot". Notice how
the regex mirrors the sentence you would use to describe the address out loud. A
good regex is mostly a sentence in disguise, and you can read it back aloud to
check it.

Two details deserve attention. Inside a bracket expression most special
characters lose their power: `.`, `+` and `%` are plain characters there. The one
exception is the dash, which makes a range unless it is first or last. And a
class never contains the character that acts as the *separator* for the next
part: because `@` is not in the local-part class, there is no way to hide a
second `@` in it.

A word of honesty: real email syntax is much stranger than this (quoted local
parts, comments, internationalised names). No sane regex covers all of it, and
nobody should try. The practical goal is a **plausibility filter**: reject typos
cheaply, then let the real mail server be the final judge by sending a
confirmation message. Know what your validator promises and what it does not.

Going further: "plausible" is easy for text. The next levels validate things
where the *numbers* matter too, such as `256.1.1.1`, where a regex alone is not
enough.
