# Debrief: Event Handlers

The last levels called things by name from one place. Event handlers turn
that around: the code that *produces* an event and the code that *reacts* to
it do not know each other. The glue is a registry.

## The mental model

Think of two phases and one table. **Subscribe**: put a function name in the
list for an event. **Publish**: look up the list and call every entry with the
payload. Order is registration order. An event nobody subscribed to is not an
error in a real bus (you may well want silence), but in this exercise it is
reported so you can see the lookup working.

## Under the hood

The table is an associative array whose values are strings. `+=` on an
array element appends text, and `${var:+ }` is the idiom for "a separator, but
only if there is already something". Splitting happens at the loop, which is
safe here because we control the names (and checked them with `declare -F`
when they came in). The payload is a different matter: it comes from outside,
so it is passed as quoted arguments and never split or globbed; try the
`*` test case.

## In real work

Everything from `trap` (one handler per signal) to Git hooks to GUI
toolkits uses this idea. In scripts it keeps cross-cutting concerns like
notification, logging and metrics out of the business code: the deploy
function emits `deploy`, and nobody has to edit it when Priya wants an audit
line.

## Going further

Sometimes the problem is not "who is told" but "how is an object put
together". Next, the builder pattern.
