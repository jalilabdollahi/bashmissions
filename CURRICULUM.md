# BashMissions — Curriculum

**26 modules · 500 missions · from "I know a few commands" to "I automate production"**

You are the newest operations engineer at **Lanternfish Hosting**, a small company
that runs servers for local businesses. Each module is one stretch of your first
year there; each mission is a real task someone hands you. Every mission teaches
one new idea and only uses ideas from earlier missions.

Difficulty: Beginner (modules 1–5) · Intermediate (6–13) · Advanced (14–22) · Expert (23–26)

---

## Module 1 — Hello, Terminal (18 levels) · Beginner
*Day one. Mara, your mentor, wants to see you make the terminal talk.*
Directory: `module-01-hello-world-output`

| Level | Title | Concept |
|---|---|---|
| 1 | Your First Script | shebang line, `echo` |
| 2 | Two Lines of Output | several `echo` commands, output order |
| 3 | Quotes Keep Your Spaces | double quotes preserve spacing |
| 4 | Single Quotes Are Literal | `'...'` stops `$` expansion |
| 5 | Escapes with printf | `\n` and `\t` in `printf` |
| 6 | printf Placeholders | `%s` and `%d` with arguments |
| 7 | Padding Columns | field widths `%-10s` `%5d` |
| 8 | No Trailing Newline | `printf` without `\n`, `echo -n` |
| 9 | Talking to stderr | `>&2` for messages |
| 10 | Comments Are for Humans | `#` comments and a header block |
| 11 | Exit Codes Speak | `exit N` |
| 12 | Reading the Environment | `$USER`, `$HOME` |
| 13 | Command Substitution | `$(command)` inside output |
| 14 | The Script Knows Its Name | `$0` and `basename` |
| 15 | Here-Document Banner | `cat <<EOF` |
| 16 | Color Codes | ANSI escapes with `printf` |
| 17 | A Boxed Banner | building lines with `printf` repetition |
| 18 | Status Card | combining printf, here-docs, stderr and exit |

---

## Module 2 — Variables (18 levels) · Beginner
*Mara hands you the server inventory. Time to store and reuse values.*
Directory: `module-02-variables-data-types`

| Level | Title | Concept |
|---|---|---|
| 19 | Store a Value | `name=value` (no spaces) |
| 20 | Braces Around Names | `${var}_suffix` |
| 21 | Quote Your Variables | `"$var"` keeps spaces and stars |
| 22 | Glue Strings Together | concatenation |
| 23 | Capture Command Output | `var=$(command)` |
| 24 | Read-Only Settings | `readonly` |
| 25 | Unset and Check | `unset`, `${var+set}` |
| 26 | Integer Variables | `declare -i` |
| 27 | Fallback Values | `${var:-default}` |
| 28 | Assign a Default | `${var:=default}` |
| 29 | Fail Loudly When Missing | `${var:?message}` |
| 30 | Empty Is Not Unset | `${var-x}` vs `${var:-x}` |
| 31 | Exported to Children | `export` and child processes |
| 32 | Environment Overrides | settings from the environment with fallbacks |
| 33 | Swap Two Values | temporary variable |
| 34 | Indirect References | `${!name}` |
| 35 | The Last Exit Status | `$?` |
| 36 | Server Profile Card | combining variables into a report |

---

## Module 3 — Arguments & Input (20 levels) · Beginner
*Your scripts get users. Users pass arguments and type things.*
Directory: `module-03-arguments-input`

| Level | Title | Concept |
|---|---|---|
| 37 | First Argument | `$1` |
| 38 | Several Arguments | `$1 $2 $3` |
| 39 | Counting Arguments | `$#` |
| 40 | Keep Arguments Intact | `"$@"` vs `$@` |
| 41 | Join Arguments | `"$*"` and `IFS` |
| 42 | Walk with shift | `shift` |
| 43 | Require an Argument | usage message, `exit 2` |
| 44 | Optional Second Argument | `${2:-default}` |
| 45 | Read a Line | `read -r` from stdin |
| 46 | Prompt on stderr | `read -p` |
| 47 | Read Several Fields | `read -r a b c` |
| 48 | Read into an Array | `read -ra` |
| 49 | Secret Input | `read -s`, never echo secrets |
| 50 | Is It a Number? | `[[ $x =~ ^[0-9]+$ ]]` |
| 51 | Reject Empty Input | `-z` check |
| 52 | Arguments or stdin | fall back to stdin when no args |
| 53 | Read Until the End | `while read` until EOF |
| 54 | Long Flags by Hand | `--name value` with `while`/`case` |
| 55 | getopts Basics | `getopts "vn:"` |
| 56 | getopts Error Handling | invalid options, missing values |

---

## Module 4 — Making Decisions (22 levels) · Beginner
*The on-call runbook is full of "if this, then that". Automate it.*
Directory: `module-04-conditionals`

| Level | Title | Concept |
|---|---|---|
| 57 | Your First if | `if [[ ... ]]; then` |
| 58 | if and else | two branches |
| 59 | The elif Ladder | several branches |
| 60 | Same String? | `==` |
| 61 | Different String? | `!=` |
| 62 | Empty or Not | `-z`, `-n` |
| 63 | Comparing Numbers | `-lt -le -gt -ge -eq -ne` |
| 64 | Arithmetic Tests | `(( a > b ))` |
| 65 | Both Must Be True | `&&` |
| 66 | Either Will Do | `\|\|` |
| 67 | Flip a Condition | `!` |
| 68 | Does It Exist? | `-e -f -d` |
| 69 | Permission Checks | `-r -w -x` |
| 70 | Empty File? | `-s` |
| 71 | Which File Is Newer? | `-nt`, `-ot` |
| 72 | Glob Matching in [[ ]] | `== *.log` |
| 73 | case Statements | `case ... esac` |
| 74 | case with Patterns | `a\|b)`, `*.tar.gz)` |
| 75 | One-Line Decisions | `cmd && a \|\| b` and its trap |
| 76 | Is the Tool Installed? | `command -v` |
| 77 | Platform Branches | `uname` in a condition |
| 78 | The Deploy Gate | nested decisions |

---

## Module 5 — Loops (22 levels) · Beginner → Intermediate
*Fifty servers, one script. Repetition is where Bash starts saving you hours.*
Directory: `module-05-loops`

| Level | Title | Concept |
|---|---|---|
| 79 | Loop over a List | `for x in a b c` |
| 80 | Brace Ranges | `{1..5}`, `{01..10}` |
| 81 | C-Style for | `for ((i=0; i<n; i++))` |
| 82 | while with a Counter | `while (( i < n ))` |
| 83 | until It Is Ready | `until` |
| 84 | Break Out Early | `break` |
| 85 | Skip with continue | `continue` |
| 86 | Loop over Arguments | `for arg in "$@"` |
| 87 | Loop over Files | globs, `nullglob` |
| 88 | Line by Line | `while IFS= read -r line` |
| 89 | Count What Matches | counting inside a loop |
| 90 | Nested Loops | grids and combinations |
| 91 | Number the Lines | loop with an index |
| 92 | Ask Until Valid | retry reading input |
| 93 | Running Totals | accumulating values |
| 94 | The Pipe Subshell Trap | `cmd \| while read` loses variables |
| 95 | select Menus | `select` built-in |
| 96 | Doubling Delays | computing a backoff schedule |
| 97 | Loop over Command Output | `while read ... < <(cmd)` |
| 98 | Sequences with a Step | `seq` and step ranges |
| 99 | Stop at the First Match | search loop with early exit |
| 100 | Background Jobs and wait | `&` and `wait` |

---

## Module 6 — Functions (20 levels) · Intermediate
*Your scripts are getting long. Mara: "If you copy-paste it twice, make it a function."*
Directory: `module-06-functions`

| Level | Title | Concept |
|---|---|---|
| 101 | Define and Call | `name() { ...; }` |
| 102 | Function Arguments | `$1` inside functions |
| 103 | Return a Status | `return N` |
| 104 | Functions in Conditions | `if my_check; then` |
| 105 | Return Data on stdout | `result=$(fn)` |
| 106 | Local Variables | `local` |
| 107 | The Global Leak | finding a variable clobbered by a function |
| 108 | Default Parameters | `${1:-default}` in functions |
| 109 | Guard Clauses | validate early, return early |
| 110 | Source a Library | `source lib.sh` |
| 111 | Recursion: Factorial | a function calling itself |
| 112 | Recursion: Directory Tree | walking nested folders |
| 113 | Callbacks by Name | passing a function name |
| 114 | Functions Inside Loops | reuse per item |
| 115 | Redefining a Function | later definitions win |
| 116 | A die() Helper | message + exit code |
| 117 | A log() Helper | levels and prefixes |
| 118 | Name References | `local -n` |
| 119 | Return Several Values | `printf` + `read` |
| 120 | Your Function Toolkit | combining helpers |

---

## Module 7 — String Surgery (22 levels) · Intermediate
*Hostnames, versions, paths: everything is a string. Bash can cut them without extra tools.*
Directory: `module-07-string-manipulation`

| Level | Title | Concept |
|---|---|---|
| 121 | How Long Is It? | `${#str}` |
| 122 | Substrings by Offset | `${str:2:5}` |
| 123 | Counting from the End | `${str: -3}` |
| 124 | Strip a Prefix | `${str#pattern}` |
| 125 | Strip the Longest Prefix | `${str##pattern}` |
| 126 | Strip a Suffix | `${str%pattern}` |
| 127 | Strip the Longest Suffix | `${str%%pattern}` |
| 128 | Replace the First Match | `${str/old/new}` |
| 129 | Replace Every Match | `${str//old/new}` |
| 130 | Anchored Replacements | `${str/#old/new}`, `${str/%old/new}` |
| 131 | UPPER and lower | `${str^^}`, `${str,,}` |
| 132 | Capitalize Words | `${word^}` per word |
| 133 | Trim Whitespace | extglob or pattern trimming |
| 134 | Pad and Truncate | `printf %-10.10s` |
| 135 | Split on a Delimiter | `IFS=: read -ra` |
| 136 | Join with a Separator | joining array items |
| 137 | Starts With, Ends With | `[[ $s == pre* ]]` |
| 138 | Contains a Substring | `[[ $s == *sub* ]]` |
| 139 | Count a Character | removing everything else |
| 140 | Reverse a String | character loop |
| 141 | Regex Match | `[[ $s =~ regex ]]` |
| 142 | Capture Groups | `BASH_REMATCH` |

---

## Module 8 — Arithmetic (14 levels) · Intermediate
*Capacity planning day. Gus from finance wants numbers, and they had better be right.*
Directory: `module-08-arithmetic`

| Level | Title | Concept |
|---|---|---|
| 143 | Add Two Numbers | `$(( a + b ))` |
| 144 | Operator Precedence | parentheses in arithmetic |
| 145 | Division and Remainder | `/` and `%` |
| 146 | Powers | `**` |
| 147 | Increment and Decrement | `(( i++ ))`, `(( i-- ))` |
| 148 | Compound Assignment | `+=`, `*=` |
| 149 | let and (( )) | `let` vs `(( ))` |
| 150 | Arithmetic Conditions | `if (( ... ))` |
| 151 | Decimals with awk | floating point via `awk` |
| 152 | Percentages Without Floats | fixed-point integer math |
| 153 | Number Bases | `16#ff`, `printf %x %o` |
| 154 | Random in a Range | `$RANDOM % n` |
| 155 | Sum, Min, Max | single-pass statistics |
| 156 | Rounding Division | round-half-up with integers |

---

## Module 9 — Arrays & Maps (22 levels) · Intermediate
*Lists of servers, maps of owners. Time for real data structures.*
Directory: `module-09-arrays`

| Level | Title | Concept |
|---|---|---|
| 157 | Create an Array | `arr=(a b c)` |
| 158 | Index into It | `${arr[1]}`, `${arr[-1]}` |
| 159 | All Elements Safely | `"${arr[@]}"` |
| 160 | Array Length | `${#arr[@]}` |
| 161 | Append Items | `arr+=(x)` |
| 162 | Remove an Item | `unset 'arr[i]'` and gaps |
| 163 | Slices | `${arr[@]:1:2}` |
| 164 | Iterate Values | `for x in "${arr[@]}"` |
| 165 | Iterate Indexes | `${!arr[@]}` |
| 166 | mapfile from a File | `mapfile -t` |
| 167 | mapfile from a Command | `mapfile -t < <(cmd)` |
| 168 | Search an Array | membership test |
| 169 | Sort an Array | `sort` round-trip |
| 170 | Remove Duplicates | unique items, order kept |
| 171 | Associative Arrays | `declare -A` |
| 172 | Counting with a Map | `map[$k]+=1` |
| 173 | Iterate Keys in Order | sorted keys |
| 174 | Does the Key Exist? | `[[ -v map[$k] ]]` |
| 175 | Delete a Key | `unset 'map[$k]'` |
| 176 | Arrays into Functions | name references |
| 177 | Two Lists into One Map | zipping arrays |
| 178 | A Grid in a Map | `map[$row,$col]` |

---

## Module 10 — Streams & Redirection (18 levels) · Intermediate
*Logs everywhere. You learn to steer every byte where it belongs.*
Directory: `module-10-redirection-pipelines-in-scripts`

| Level | Title | Concept |
|---|---|---|
| 179 | Write to a File | `>` |
| 180 | Append to a File | `>>` |
| 181 | Errors to a File | `2>` |
| 182 | Both Streams, One File | `&>` |
| 183 | Merge stderr into stdout | `2>&1` and order |
| 184 | Silence Is Golden | `/dev/null` |
| 185 | Input from a File | `<` |
| 186 | Here-Docs with Variables | `<<EOF` expansion |
| 187 | Quoted Here-Docs | `<<'EOF'` |
| 188 | Here-Strings | `<<<` |
| 189 | Build a Pipeline | `a \| b \| c` |
| 190 | Who Failed in the Pipe? | `PIPESTATUS` |
| 191 | Compare Two Outputs | `diff <(...) <(...)` |
| 192 | Keep a Copy with tee | `tee` |
| 193 | Open a File Descriptor | `exec 3>file` |
| 194 | Read Two Files at Once | `read -u 3` |
| 195 | Close and Restore | saving and restoring stdout |
| 196 | Redirect a Whole Block | `{ ...; } > file` |

---

## Module 11 — Failing Safely (18 levels) · Intermediate
*Theo's deploy script deleted the wrong folder. Never again.*
Directory: `module-11-error-handling-defensive-scripting`

| Level | Title | Concept |
|---|---|---|
| 197 | Check the Status | `$?` after a command |
| 198 | Or Else Exit | `cmd \|\| exit 1` |
| 199 | What set -e Does | errexit and its exceptions |
| 200 | set -u Catches Typos | nounset |
| 201 | Failures Inside Pipes | `pipefail` |
| 202 | Strict Mode | `set -euo pipefail` together |
| 203 | Cleanup on Exit | `trap ... EXIT` |
| 204 | Report the Failing Line | `trap ... ERR` |
| 205 | Handle Ctrl-C | `trap ... INT` |
| 206 | Graceful Shutdown | `trap ... TERM` |
| 207 | Temp Files That Vanish | `mktemp` + trap |
| 208 | Meaningful Exit Codes | a code per failure type |
| 209 | Validate Before Acting | checking all inputs first |
| 210 | Retry a Flaky Command | bounded retries |
| 211 | A Time Limit by Hand | background job + `kill` |
| 212 | Dependency Check | missing tools listed at once |
| 213 | Error Messages That Help | what, where, how to fix |
| 214 | Exit Codes Through Layers | propagating status |

---

## Module 12 — Patterns & Regex (18 levels) · Intermediate
*Priya from security needs to find needles in log haystacks.*
Directory: `module-12-regular-expressions-in-bash`

| Level | Title | Concept |
|---|---|---|
| 215 | Your First =~ | regex match in `[[ ]]` |
| 216 | Anchors | `^` and `$` |
| 217 | Character Classes | `[a-z]`, `[[:digit:]]` |
| 218 | Quantifiers | `*` `+` `?` `{n,m}` |
| 219 | Alternation | `(a\|b)` |
| 220 | Capture One Group | `BASH_REMATCH[1]` |
| 221 | Capture Several Groups | multiple captures |
| 222 | Validate an Email Address | practical email check |
| 223 | Validate an IPv4 Address | regex + range check |
| 224 | Validate a Date | `YYYY-MM-DD` + month/day ranges |
| 225 | Regex in a Variable | quoting pitfalls |
| 226 | grep -E Filters | extended regex with grep |
| 227 | Extract with grep -o | only the matching part |
| 228 | Count and Invert | `grep -c`, `grep -v` |
| 229 | sed Substitution | `s/old/new/g` |
| 230 | sed Back-References | `\1` in replacements |
| 231 | Negated Classes | `[^"]*` instead of lazy matching |
| 232 | Log Line Parser | combining captures |

---

## Module 13 — Working with Files (18 levels) · Intermediate
*The file server is a mess. You get to clean it — carefully.*
Directory: `module-13-file-operations-in-scripts`

| Level | Title | Concept |
|---|---|---|
| 233 | Make Directories and Files | `mkdir -p`, `touch` |
| 234 | Don't Clobber | `set -o noclobber` |
| 235 | Append Entries | timestamped appends |
| 236 | Slurp a File | `$(<file)` |
| 237 | Pick One Line | `sed -n 'Np'` |
| 238 | Count Lines and Words | portable `wc` usage |
| 239 | Copy with Checks | `cp` + verification |
| 240 | Batch Rename | renaming by extension |
| 241 | Delete Carefully | path guard before `rm` |
| 242 | Temporary Files | `mktemp` |
| 243 | Temporary Directories | `mktemp -d` |
| 244 | Find by Name | `find -name` |
| 245 | Find by Type and Size | `find -type -size` |
| 246 | Find by Age | `find -mtime`, `-newer` |
| 247 | Lock with mkdir | atomic lock directory |
| 248 | Atomic Writes | write temp, then `mv` |
| 249 | Rotate Backups | `.1 .2 .3` rotation |
| 250 | Directory Summary | counts per extension |

---

## Module 14 — Text Processing (22 levels) · Advanced
*Reports, exports, CSVs. The classic Unix tools become your power tools.*
Directory: `module-14-text-processing-in-scripts`

| Level | Title | Concept |
|---|---|---|
| 251 | Cut Columns | `cut -d -f` |
| 252 | Sort Lines | `sort` |
| 253 | Sort by Key and Number | `sort -t -k -n` |
| 254 | Collapse Repeats | `uniq` |
| 255 | Frequency Table | `sort \| uniq -c \| sort -rn` |
| 256 | Translate Characters | `tr` |
| 257 | Delete and Squeeze | `tr -d`, `tr -s` |
| 258 | Head and Tail Windows | line ranges |
| 259 | awk Fields | `$1`, `$NF` |
| 260 | awk Filters | conditions on fields |
| 261 | awk Sums and Averages | `END` blocks |
| 262 | awk Separators | `-F` and `OFS` |
| 263 | awk Group By | awk arrays |
| 264 | sed Delete Lines | `/pattern/d` |
| 265 | sed Line Ranges | `/start/,/end/p` |
| 266 | sed In Place with Backup | `sed -i.bak` |
| 267 | Side by Side | `paste` |
| 268 | Join on a Key | `join` |
| 269 | Set Differences | `comm` |
| 270 | Align a Table | `printf` columns |
| 271 | Parse key=value Files | `IFS='=' read` |
| 272 | Top-N Report | combining tools |

---

## Module 15 — Script Craft (18 levels) · Advanced
*Your scripts will outlive you. Write them like it.*
Directory: `module-15-script-structure-best-practices`

| Level | Title | Concept |
|---|---|---|
| 273 | A Proper Header | env shebang + strict mode + description |
| 274 | Usage and --help | usage function |
| 275 | The main() Pattern | `main "$@"` |
| 276 | Constants Block | `readonly` configuration |
| 277 | Filenames with Spaces | quoting everywhere |
| 278 | Commands in Arrays | building argument lists safely |
| 279 | printf Over echo | data that looks like flags |
| 280 | Don't Parse ls | globs instead of `ls` output |
| 281 | Local by Default | function hygiene |
| 282 | Small Functions | one job per function |
| 283 | Flags, Positionals and -- | full argument parsing |
| 284 | Subcommands | `tool add/list/remove` |
| 285 | Settings from the Environment | validated env config |
| 286 | Idempotent Scripts | safe to run twice |
| 287 | Library or Program? | `BASH_SOURCE` guard |
| 288 | Version Guard | `BASH_VERSINFO` |
| 289 | POSIX-Friendly Code | `[ ]` and `case` instead of bashisms |
| 290 | Self-Documenting Help | help text read from the script itself |

---

## Module 16 — Debugging (14 levels) · Advanced
*Something broke at 3 a.m. You learn to make scripts explain themselves.*
Directory: `module-16-debugging-scripts`

| Level | Title | Concept |
|---|---|---|
| 291 | Trace with set -x | xtrace on stderr |
| 292 | Trace Only the Suspect | `set -x` / `set +x` around a block |
| 293 | PS4 with Line Numbers | custom trace prefix |
| 294 | Trace to a File | `BASH_XTRACEFD` |
| 295 | A DEBUG Switch | conditional debug output |
| 296 | LINENO in Messages | `$LINENO` |
| 297 | The Call Stack | `FUNCNAME`, `BASH_LINENO` |
| 298 | Where Was This Defined? | `BASH_SOURCE` in libraries |
| 299 | ERR Trap with Context | command, line, status |
| 300 | Dry-Run Mode | print instead of execute |
| 301 | Assertions | `assert_eq` helper |
| 302 | A Mini Test Harness | running test functions |
| 303 | Fix the Off-by-One | debugging a broken fixture script |
| 304 | Find the Failing Step | bisecting a list of steps |

---

## Module 17 — Processes & Signals (18 levels) · Advanced
*The batch jobs are slow. Run them in parallel — without losing control.*
Directory: `module-17-process-management-in-scripts`

| Level | Title | Concept |
|---|---|---|
| 305 | Run in the Background | `&` and `$!` |
| 306 | Wait for One Job | `wait $pid` and its status |
| 307 | Wait for Them All | collecting every status |
| 308 | Still Running? | `kill -0` |
| 309 | Stop a Job | `kill` + `wait` |
| 310 | A Worker Limit | `wait -n` |
| 311 | Subshell Isolation | `( ... )` |
| 312 | cd Without Consequences | directory changes in a subshell |
| 313 | Command Groups | `{ ...; }` |
| 314 | Collect Job Results | one temp file per job |
| 315 | Named Pipes | `mkfifo` |
| 316 | Signal Yourself | `kill -USR1 $$` |
| 317 | Reload on HUP | config reload handler |
| 318 | Ignore and Restore Signals | `trap ''` and `trap -` |
| 319 | Parallel xargs | `xargs -P` |
| 320 | Safe Names with xargs -0 | `find -print0 \| xargs -0` |
| 321 | A Job Queue from a File | worker loop |
| 322 | A FIFO Semaphore | tokens through a pipe |

---

## Module 18 — Function Patterns (18 levels) · Advanced
*Mara's toolbox: patterns that make big Bash programs manageable.*
Directory: `module-18-advanced-functions-patterns`

| Level | Title | Concept |
|---|---|---|
| 323 | Dispatch Table | map of commands to functions |
| 324 | Plugin Loader | sourcing every file in a folder |
| 325 | Before and After Hooks | hook arrays |
| 326 | Memoize | caching results in a map |
| 327 | Function Factories | generating functions |
| 328 | Decorators | wrapping an existing function |
| 329 | Does the Function Exist? | `declare -F` |
| 330 | Safe Dynamic Calls | allow-listed function names |
| 331 | Forward Every Argument | `"$@"` pass-through |
| 332 | Generators with State | next-value functions |
| 333 | An Iterator over Lines | cursor in a file |
| 334 | Event Handlers | register and emit |
| 335 | Builder Pattern | chained configuration |
| 336 | Strategy Pattern | swappable algorithms |
| 337 | Middleware Chain | pipeline of transformers |
| 338 | Retry Wrapper | retry any command |
| 339 | Timing Wrapper | `SECONDS` / `EPOCHREALTIME` |
| 340 | Audit Wrapper | log every call |

---

## Module 19 — Configuration (14 levels) · Advanced
*Every customer wants it "slightly different". Configuration done right.*
Directory: `module-19-configuration-environment`

| Level | Title | Concept |
|---|---|---|
| 341 | Load a .env File Safely | parse, never `source` |
| 342 | Layered Defaults | defaults, file, environment |
| 343 | Flags Beat Everything | precedence rules |
| 344 | Required Keys | report all missing keys |
| 345 | XDG Config Paths | `XDG_CONFIG_HOME` fallback |
| 346 | Find the Project Config | walking up directories |
| 347 | Type-Check Values | ints, booleans, enums |
| 348 | Mask Secrets | redacted output |
| 349 | Secrets from Files | `*_FILE` convention |
| 350 | INI Sections | `[section]` parsing |
| 351 | Reload on Signal | re-read config on HUP |
| 352 | Show Effective Config | sorted final values |
| 353 | Migrate an Old Format | config upgrade |
| 354 | Diff Two Configs | added, removed, changed |

---

## Module 20 — Security (14 levels) · Advanced
*Priya runs a security review of every script. Pass it.*
Directory: `module-20-script-security`

| Level | Title | Concept |
|---|---|---|
| 355 | Quote to Stop Injection | unquoted input becomes code |
| 356 | Replace eval | arrays and `case` instead of `eval` |
| 357 | Allow-List Input | accept only known-good values |
| 358 | Safe Temp Files | unpredictable names |
| 359 | umask for Secrets | files born private |
| 360 | Find World-Writable Files | `find -perm` |
| 361 | Refuse to Run as Root | `id -u` guard |
| 362 | Path Traversal Guard | rejecting `..` escapes |
| 363 | Lock Down PATH | trusted `PATH` at start |
| 364 | Globs Not ls | safe file iteration |
| 365 | Symlink Checks | `-L` before writing |
| 366 | Create Exclusively | noclobber against races |
| 367 | Forget Secrets | `unset` after use |
| 368 | Redact Logs | scrubbing tokens and passwords |

---

## Module 21 — Talking to the Network (14 levels) · Advanced
*The status page, the billing API, the DNS. Scripts that speak HTTP.*
Directory: `module-21-networking-in-scripts`

| Level | Title | Concept |
|---|---|---|
| 369 | Fetch a Page | `curl -s` |
| 370 | HTTP Status Codes | `-w '%{http_code}'` |
| 371 | POST Form Data | `-d` |
| 372 | JSON with Headers | `-H`, JSON bodies |
| 373 | Bearer Tokens | tokens from env, never printed |
| 374 | Fail on HTTP Errors | `--fail` and exit codes |
| 375 | Respect Retry-After | reading response headers |
| 376 | Extract a JSON Field | `sed`/`grep` on simple JSON |
| 377 | Follow Pagination | next-page loop |
| 378 | Is the Port Open? | `nc -z` |
| 379 | DNS Lookups | `dig +short` |
| 380 | Download and Verify | checksum check |
| 381 | Rate-Limited Calls | spacing requests |
| 382 | Uptime Probe Report | probing a host list |

---

## Module 22 — Logging & Monitoring (18 levels) · Advanced
*You join the on-call rotation. Your scripts now watch the servers for you.*
Directory: `module-22-logging-monitoring-scripts`

| Level | Title | Concept |
|---|---|---|
| 383 | Timestamped Log Lines | `printf '%(...)T'` |
| 384 | Log Levels and Filtering | `LOG_LEVEL` threshold |
| 385 | Log to File and Screen | `tee -a` |
| 386 | Rotate by Size | size check + rename |
| 387 | Structured Logs | `key=value` lines |
| 388 | Disk Usage Alert | `df -P` parsing |
| 389 | Load Average Check | parsing `uptime` |
| 390 | Memory from meminfo | `/proc/meminfo` format |
| 391 | PID File Health | stale PID detection |
| 392 | Heartbeat Freshness | file age checks |
| 393 | Error Spike Detector | counts per minute |
| 394 | Metrics File | Prometheus text format |
| 395 | Terminal Status Board | aligned dashboard |
| 396 | Watchdog Restart | detect and restart |
| 397 | Alert Webhook | posting alerts |
| 398 | Tamper-Evident Audit Trail | sequence + checksum chain |
| 399 | Collapse Repeated Messages | "repeated N times" |
| 400 | Daily Summary | aggregating a day of logs |

---

## Module 23 — Build & Deploy (18 levels) · Expert
*Lanternfish ships every day. You own the pipeline scripts.*
Directory: `module-23-automation-ci-cd-scripts`

| Level | Title | Concept |
|---|---|---|
| 401 | Step Runner | stop on the first failing step |
| 402 | Run All Linters | collect every failure |
| 403 | Parse Test Results | TAP output |
| 404 | Coverage Gate | threshold check |
| 405 | Semver Bump | major/minor/patch |
| 406 | Changelog from Commits | grouping commit messages |
| 407 | Tag a Release | `git tag` via stub |
| 408 | Version from git describe | parsing describe output |
| 409 | Build Matrix | every OS × version |
| 410 | Artifact Names and Checksums | release manifest |
| 411 | Build and Tag an Image | `docker` via stub |
| 412 | Deploy with a Health Gate | polling until healthy |
| 413 | Roll Back on Failure | restoring the previous release |
| 414 | Render a Template | `${VAR}` substitution |
| 415 | Promote Between Environments | dev → staging → prod |
| 416 | Cron Wrapper | lock, log, exit status |
| 417 | Idempotent Setup | check before create |
| 418 | Prune Old Artifacts | keep the newest N |

---

## Module 24 — Data Wrangling (18 levels) · Expert
*Gus wants reports. Lots of reports. From messy data.*
Directory: `module-24-data-processing-scripts`

| Level | Title | Concept |
|---|---|---|
| 419 | Parse CSV Rows | `IFS=, read` |
| 420 | Validate CSV Schema | column counts and header |
| 421 | Filter Rows | conditions on columns |
| 422 | Reorder Columns | `awk` projection |
| 423 | Column Statistics | sum, average, min, max |
| 424 | Join Two CSVs | matching on a key |
| 425 | CSV to JSON | escaping and formatting |
| 426 | JSON Lines to CSV | simple field extraction |
| 427 | Parse Access Logs | combined log format |
| 428 | Status Code Breakdown | grouping by class |
| 429 | Top Talkers | busiest clients |
| 430 | Time Window Filter | ISO timestamps compare as text |
| 431 | Pivot Table | rows × columns totals |
| 432 | Markdown Report | generated tables |
| 433 | HTML Report | here-doc templates with escaping |
| 434 | Diff Two Datasets | added, removed, changed rows |
| 435 | Latest Record Wins | dedupe by key |
| 436 | Streaming Transform | no temp files, constant memory |

---

## Module 25 — Running the Fleet (20 levels) · Expert
*You are trusted with the whole fleet. Real sysadmin automation.*
Directory: `module-25-system-automation-scripts`

| Level | Title | Concept |
|---|---|---|
| 437 | Timestamped Backup | `tar` archives |
| 438 | Backup Retention | keep daily/weekly |
| 439 | Verify a Backup | checksum manifest |
| 440 | Provision Users from CSV | `useradd` via stub |
| 441 | Offboard a User | lock, archive, report |
| 442 | Fleet Command Runner | `ssh` via stub |
| 443 | Config Push with Dry-Run | `scp` via stub |
| 444 | Certificate Expiry Report | days until expiry |
| 445 | Log Archiver | compress old logs |
| 446 | Disk Cleanup Policy | age and size rules |
| 447 | Package Audit | installed vs policy |
| 448 | Rolling Restart | one host at a time |
| 449 | Database Dump Rotation | dump, compress, prune |
| 450 | Port Inventory | open ports per host |
| 451 | Firewall Rule Audit | parsing rule exports |
| 452 | SSH Hardening Check | `sshd_config` audit |
| 453 | Cron Inventory | every crontab, one table |
| 454 | Account Audit | `/etc/passwd`-style data |
| 455 | Incident Snapshot | evidence folder + manifest |
| 456 | Compliance Report | pass/fail checklist |

---

## Module 26 — Storm Season: War Games (44 levels) · Expert
*Storm season hits the coast and the fleet. Every mission is a full incident or a
full tool: several concepts, one production-quality script.*
Directory: `module-26-war-games-mega-scripts`

| Level | Title | Mission |
|---|---|---|
| 457 | The Deployment Pipeline | build → test → deploy → verify → rollback on failure |
| 458 | The Log Investigator | multi-format logs → incident timeline |
| 459 | The Secret Rotator | rotate credentials, update configs, verify |
| 460 | The Capacity Planner | usage history → growth projection → alert |
| 461 | The User Auditor | orphans, stale accounts, bad permissions |
| 462 | The API Poller | detect state changes, fire webhooks |
| 463 | The Backup Verifier | restore + checksum every backup in the window |
| 464 | The Cron Analyzer | parse crontabs, find overlaps |
| 465 | The Config Drift Detector | live vs golden config |
| 466 | The Release Manager | tag, changelog, artifacts, notify |
| 467 | The Certificate Watchdog | expiry alerts + renew stub |
| 468 | The Service Health Dashboard | many services, one screen |
| 469 | The Incident Responder | snapshot on alert trigger |
| 470 | The Multi-Env Deployer | promotion gates |
| 471 | The Data Pipeline | ingest, validate, transform, load, report |
| 472 | The Test Harness Builder | register, run, report tests |
| 473 | The Plugin System | discovery, ordering, isolation |
| 474 | The CLI Framework | subcommands, flags, help, version |
| 475 | The Config Manager | load, validate, merge, export |
| 476 | The Job Queue | FIFO queue with workers |
| 477 | The Audit Logger | tamper-evident append-only log |
| 478 | The Self-Updating Script | download, verify, replace self |
| 479 | The Distributed Lock | lock with owner and expiry |
| 480 | The Rate Limiter | token bucket |
| 481 | The Circuit Breaker | closed / open / half-open |
| 482 | The Feature Flag System | config-driven toggles with rollout % |
| 483 | The Blue-Green Switcher | atomic symlink switch |
| 484 | The Canary Releaser | gradual shift + automatic abort |
| 485 | The Chaos Monkey | seeded fault injection |
| 486 | The SLA Monitor | uptime % and error budget |
| 487 | The Cost Analyzer | usage × price list → invoice |
| 488 | The Security Scanner | misconfigurations and weak permissions |
| 489 | The Forensics Collector | preserve evidence with hashes |
| 490 | The Self-Healing Script | detect → remediate → verify |
| 491 | The Dependency Graph | topological order, cycle detection |
| 492 | The Template Engine | variables, conditionals, loops |
| 493 | The State Machine | states, transitions, validation |
| 494 | The Event Bus | publish/subscribe |
| 495 | The Retry Framework | strategies: fixed, linear, exponential |
| 496 | The Observability Kit | metrics + logs + spans |
| 497 | The Compliance Enforcer | apply and verify policy rules |
| 498 | The Migration Runner | ordered, idempotent migrations |
| 499 | The Ultimate Deployer | GitOps-style full deploy |
| 500 | The Grand Finale | the Lanternfish ops toolkit |
