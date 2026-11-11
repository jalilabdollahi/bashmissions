# Debrief: UPPER and lower

Case conversion is built into parameter expansion since Bash 4. One operator
character applies to the first letter (`^` and `,`), doubled it applies to every
letter (`^^` and `,,`). That symmetry is easy to remember: the caret points up,
the comma sits low.

The practical value is **normalisation**. Computers compare strings exactly:
`Aa:Bb` and `aa:bb` are different values to a database, a hash table or an `==`
test, even though a human sees the same address. Converting both sides to one
case before comparing removes a whole class of "it works for some customers"
bugs. Host names, e-mail domains, MAC addresses, file extensions (`.JPG` versus
`.jpg`), and user-typed yes/no answers are the usual suspects.

Case rules depend on the locale. With `LC_ALL=C`, as in our tests, only the
letters A to Z are affected. In other locales accented letters may be converted
too. Whenever the data matters for security or storage, keep to ASCII or test
the locale you run in.

Also note the original variable is never changed: these are *views* of the
value. Assign the result if you want to keep it: `mac=${mac,,}`.

Going further: converting only the first letter is useful for names and titles.
That is next.
