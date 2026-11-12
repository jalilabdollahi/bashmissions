# Walkthrough: The State Machine

## The plan
A state machine replaces a pile of `if` statements with a table. States are the situations a thing can be in, events are what can happen to it, and a transition says "in state X, event E leads to state Y, if the guards pass". Writing the rules as data has two big payoffs. The rules can be *checked* (are there states you can never reach? states you can never leave?) and they can be *enforced* uniformly, by one small function that looks the event up in the table.

## Step by step

1. **Parse the definition.** Each line is `initial`, `final`, or a transition with optional `role=` and `require=` guards. Every malformed line is reported with its number; only after the whole file has been read does the program exit 2. The data model is a handful of associative arrays keyed by `"$from|$event"`: destination, allowed roles, required field. A per-state `events` list answers "what can leave this state?" in one lookup. When two lines share the same key, the first wins and the second is remembered as a duplicate for `validate` to report.

2. **Validate the design.** Reachability is a breadth-first search from the initial state. Anything never reached is dead weight or a missing transition. A state that is not final and has no outgoing transitions is a trap: tickets enter and never leave. A final state with outgoing transitions is a contradiction. Sorting the reports makes the output stable and easy to diff when someone edits the machine.

3. **Load the ticket.** The ticket file is simple `key=value` lines: `state`, repeated `history`, and everything else is a field. A missing file is a new ticket in the initial state, which is how the first `fire` creates it. A state name that the machine does not know means the file was edited by hand or the machine changed; refusing to continue is safer than guessing.

4. **Fire, with checks in a fixed order.** First "is this event legal in this state?" (the error lists the legal ones, which is what the user needs next). Then the *role* guard (exit 3), then the *data* guard (exit 4), after the arguments `FIELD=VALUE` have been applied, so a single call can supply the missing summary and fire the event. The order is part of the interface: a wrong role must not learn which fields are missing.

5. **Commit atomically.** Nothing is written until all checks pass. The new file goes to a temporary file in the same folder and is moved over the old one, so a crash cannot leave a ticket with half a history.

## Complete solution
The guard sequence in `fire`:
```bash
key=$state'|'$ev
[[ -n ${to[$key]:-} ]] || { echo "illegal: ..." >&2; exit 1; }
case ",${roles[$key]}," in *",$role,"*) ;; *) echo "denied: ..." >&2; exit 3 ;; esac
[[ -z ${req[$key]} || -n ${field[${req[$key]}]:-} ]] || { echo "blocked: ..." >&2; exit 4; }
```
(with the role check skipped when the list is empty).

## Try it by hand
```bash
./solution.sh fixtures/ticket.machine validate
./solution.sh fixtures/ticket.machine fire t.ticket triage oncall
./solution.sh fixtures/ticket.machine fire t.ticket mitigate oncall
./solution.sh fixtures/ticket.machine fire t.ticket resolve oncall           # blocked
./solution.sh fixtures/ticket.machine fire t.ticket resolve oncall "summary=pump replaced"
./solution.sh fixtures/ticket.machine show t.ticket
```

## Alternative
A big `case "$state:$event"` statement in the script works for three states and becomes unreadable at ten; it also cannot be validated, because the rules are code, not data. The table-driven version lets a non-programmer review the lifecycle in a text file.
