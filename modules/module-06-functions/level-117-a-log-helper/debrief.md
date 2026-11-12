# Debrief: A log() Helper

Printing is not the same as logging. A log helper adds structure: a level, a
consistent prefix, and a filter so the same script can be silent in cron and
chatty on your terminal. Every serious tool has this, from `ssh -v` to
application frameworks.

There are three ideas in this level. First, *levels are numbers in disguise*. To
say "at least as important as", the names need an order, which `case` provides.
Second, *configuration through the environment*: `LOG_LEVEL=DEBUG ./script`
changes the behaviour without editing anything, and `${LOG_LEVEL:-INFO}` gives a
sane default. Third, *stdout is for results, stderr is for messages*. The
script's real output (`checked: 80%`) stays clean for pipes while the commentary
goes to stderr; try `./solution.sh 80 2>/dev/null` to see the difference.

Notice that `log` calls `level_num` and that helper functions can call other
functions freely, as long as they are defined by the time of the call.

In production you would add a timestamp (`date +%FT%T`) and maybe a script
name. The function is the single place to put it. That is the payoff of
funnelling every message through one door.

Going further: so far arrays were off limits. The next level hands a function the
*name* of a variable, which lets it fill a list for its caller.
