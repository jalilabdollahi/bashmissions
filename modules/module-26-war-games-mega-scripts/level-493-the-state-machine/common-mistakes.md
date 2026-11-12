# Common Mistakes

- **Checking the role before the event is legal.** A user who may not do anything in this state should hear "illegal here", not "you need role lead". Check legality first, authority second, data third.
- **Writing the ticket before the checks finish.** If the required-field check fails after you already wrote `state=resolved`, the ticket is corrupt. Collect everything, check, then write once.
- **Applying `FIELD=VALUE` arguments after the `require=` test.** Then `fire ... resolve oncall summary=x` is blocked by the very field it is supplying. Apply the arguments first.
- **Forgetting duplicates.** Two lines for `open triage` mean the machine is ambiguous. The first one wins, and `validate` must say so, otherwise one of them is silently dead.
- **Treating "no outgoing transitions" as final.** A non-final state without exits is a trap. Only states declared `final` may have nowhere to go.
- **Sorting with the locale.** `sort` without `LC_ALL=C` orders `Open` and `open` differently on different machines, and error messages that list events change between hosts.
