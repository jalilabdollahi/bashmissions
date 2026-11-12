# Walkthrough: The CLI Framework

## The plan
Most hand-written command-line tools grow a `case` statement per command, a usage text per command,
and slowly drift apart: the help says `--shift`, the parser accepts `--shifts`. A framework removes the
drift by having one source of truth. Here that is the **registry**: a handful of associative arrays that
describe each command and its options. Three generic pieces read it (the help printer, the option parser,
the typo helper) and a handler per command does the real work.

## Step by step
1. **The registry.** `cmds` keeps the order (associative arrays do not), `desc`, `argword`, `minargs` and
   `maxargs` describe the positional arguments, and `opts[cmd]` is a small table, one option per line in the
   form `SHORT|LONG|VALUENAME|TEXT`. An empty value name marks a flag such as `--force`. `allowed` lists the
   legal values for options like `role`.

2. **Generated help.** `overall_help` loops over `cmds`. `command_help` assembles the usage line from what
   the registry contains: `[OPTIONS]` appears only when the command has options, and the argument word only when
   it has one. Because both screens come from the data, adding a command or an option updates `help`
   automatically.

3. **One error path.** `usage_error` prints `lantern: ...` (or `lantern CMD: ...` inside a command), the
   "Run 'lantern help ...' for usage." line, and exits with 64 (EX_USAGE from `sysexits.h`). Runtime problems
   such as a missing crew member use a different helper and exit 1. The split lets scripts calling `lantern` tell
   "you called it wrong" from "the operation failed".

4. **Hints.** Typing `lst` or `--rol` is almost right. A subsequence test (are the typed letters found in
   order inside a known name?) is cheap, needs no edit-distance code, and catches dropped letters. Hints are only
   offered for words of two or more letters and never for exact matches.

5. **The parser.** One loop handles every command. `--` stops option parsing; `-h`/`--help` prints the command
   help; anything starting with `-` is looked up in the command's option table by long or short name. A flag sets
   `opt[force]=1`; an option with a value takes either the text after `=` or the next argument, which also gets
   validated against `allowed`. Everything else is a positional argument. Options may appear before or after the
   positionals because the loop does not care about their order.

6. **Global layer.** `--db`, `-h`, `-V`, `--` are handled before the command. The database path follows the usual
   precedence of flag over environment variable over default: `db=${LANTERN_DB:-crew.db}` first, then `--db`
   overrides it.

7. **Dispatch.** After the argument counts are checked (missing and extra arguments each have a message), the
   command name is turned into a function name: `"cmd_$cmd"`.

## Try it by hand
```
./solution.sh help add
./solution.sh add Mara --role pilot
./solution.sh lst
```

## Alternative
`getopts` handles short options only and does not know about subcommands; `getopt` (GNU) is not on macOS. A
hand-written parser is about thirty lines and works the same everywhere, which is why most serious Bash tools
carry one.
