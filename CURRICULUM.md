# BashMissions — 500-Level Curriculum

**26 modules | 500 levels | Beginner → Expert**

---

## Module 1 — Hello World & Output (18 levels) · Beginner

> First contact with bash scripts: echo, variables, quoting rules.

| Level | Title | Concept |
|---|---|---|
| 1 | Your First Script | `#!/bin/bash`, `echo` |
| 2 | Print a Message | echo with a string argument |
| 3 | Single vs Double Quotes | quoting differences |
| 4 | Print Multiple Lines | multiple echo statements |
| 5 | Escape Characters | `\n`, `\t` with `echo -e` |
| 6 | printf Basics | `printf` format strings |
| 7 | printf vs echo | choosing the right output tool |
| 8 | Suppress Newline | `echo -n` |
| 9 | Print to Stderr | `echo >&2` |
| 10 | Comment Your Script | `#` comments, script header |
| 11 | Script Exit Code | `exit 0`, `exit 1` |
| 12 | Print Environment Variable | `$HOME`, `$USER` |
| 13 | Print Current Date | `$(date)` command substitution |
| 14 | Print Script Name | `$0` |
| 15 | Multi-line String | here-string with echo |
| 16 | Colorized Output | ANSI escape codes |
| 17 | Print a Banner | printf with padding |
| 18 | Print Version Info | combining variables in output |

---

## Module 2 — Variables & Data Types (18 levels) · Beginner

> Declaring, assigning, and using variables; string and integer basics.

| Level | Title | Concept |
|---|---|---|
| 19 | Assign a Variable | `name=value` (no spaces) |
| 20 | Use a Variable | `$var` and `${var}` |
| 21 | Read-Only Variables | `readonly` |
| 22 | Unset a Variable | `unset` |
| 23 | Integer Variables | `declare -i` |
| 24 | Default Values | `${var:-default}` |
| 25 | Assign If Unset | `${var:=default}` |
| 26 | Error If Unset | `${var:?error}` |
| 27 | Variable Indirection | `${!varname}` |
| 28 | Local vs Global Scope | `local` keyword (preview) |
| 29 | Export a Variable | `export` |
| 30 | Uppercase Variable | `${var^^}` |
| 31 | Lowercase Variable | `${var,,}` |
| 32 | String Length | `${#var}` |
| 33 | Substring Extraction | `${var:offset:length}` |
| 34 | Remove Prefix | `${var#pattern}` |
| 35 | Remove Suffix | `${var%pattern}` |
| 36 | Replace in String | `${var//old/new}` |

---

## Module 3 — Arguments & Input (20 levels) · Beginner

> Accepting positional arguments, reading user input, validating input.

| Level | Title | Concept |
|---|---|---|
| 37 | First Argument | `$1` |
| 38 | Multiple Arguments | `$1 $2 $3` |
| 39 | Argument Count | `$#` |
| 40 | All Arguments | `$@` vs `$*` |
| 41 | Shift Arguments | `shift` |
| 42 | Require an Argument | check `$#`, exit if missing |
| 43 | Default Argument | `${1:-default}` |
| 44 | Read from Stdin | `read var` |
| 45 | Read with Prompt | `read -p "prompt" var` |
| 46 | Read Silently | `read -s` for passwords |
| 47 | Read with Timeout | `read -t` |
| 48 | Read into Array | `read -a arr` |
| 49 | Validate Numeric Input | test with regex `[[ $var =~ ^[0-9]+$ ]]` |
| 50 | Validate Non-Empty | check `-z` |
| 51 | Read a File Line by Line | while read loop |
| 52 | Read from Pipe | detecting piped input |
| 53 | Handle Quoted Arguments | quoting in `"$@"` |
| 54 | Named Flags (manual) | parse `--flag value` with while/case |
| 55 | Getopts Basics | `getopts "ab:" opt` |
| 56 | Getopts with Required Option | error on missing optarg |

---

## Module 4 — Conditionals (22 levels) · Beginner

> if/elif/else, test expressions, file tests, string and numeric comparisons.

| Level | Title | Concept |
|---|---|---|
| 57 | Simple if Statement | `if [ condition ]; then` |
| 58 | if-else | binary decision |
| 59 | if-elif-else | multiple branches |
| 60 | Test String Equality | `[ "$a" = "$b" ]` |
| 61 | Test String Inequality | `!=` |
| 62 | Test Empty String | `-z` |
| 63 | Test Non-Empty String | `-n` |
| 64 | Numeric Comparison | `-eq -ne -lt -gt -le -ge` |
| 65 | Double Bracket Test | `[[ ... ]]` advantages |
| 66 | Logical AND in Test | `&&` inside `[[ ]]` |
| 67 | Logical OR in Test | `\|\|` inside `[[ ]]` |
| 68 | Negate a Condition | `!` |
| 69 | File Exists | `-e`, `-f`, `-d` |
| 70 | File is Readable | `-r`, `-w`, `-x` |
| 71 | File is Not Empty | `-s` |
| 72 | Compare File Ages | `-nt`, `-ot` |
| 73 | Case Statement | `case $var in ... esac` |
| 74 | Case with Glob Patterns | `case` pattern matching |
| 75 | Ternary-Style One-Liner | `[[ cond ]] && true || false` |
| 76 | Check Command Exists | `command -v` |
| 77 | Check OS Type | `uname` in condition |
| 78 | Nested if Statements | decision trees |

---

## Module 5 — Loops (22 levels) · Beginner→Intermediate

> for, while, until, break, continue, loop control patterns.

| Level | Title | Concept |
|---|---|---|
| 79 | for Loop over List | `for x in a b c` |
| 80 | for Loop over Range | `for i in {1..10}` |
| 81 | C-Style for Loop | `for ((i=0;i<10;i++))` |
| 82 | while Loop | `while [ condition ]` |
| 83 | until Loop | `until [ condition ]` |
| 84 | Infinite Loop with Break | `while true; do ... break; done` |
| 85 | Continue in Loop | skip iteration |
| 86 | Loop over Arguments | `for arg in "$@"` |
| 87 | Loop over Files | `for f in *.txt` |
| 88 | Loop over Lines of a File | `while IFS= read -r line` |
| 89 | Loop with Counter | tracking iterations |
| 90 | Nested Loops | matrix iteration |
| 91 | Loop with Index | C-style with array index |
| 92 | Loop until Input Valid | retry read loop |
| 93 | Accumulate in Loop | summing, concatenating |
| 94 | Loop with Pipe | `while read` from pipe |
| 95 | Select Menu | `select` built-in |
| 96 | Retry with Backoff | exponential wait in loop |
| 97 | Loop over Command Output | `while IFS= read -r line < <(cmd)` |
| 98 | Generate a Sequence | `seq` in loop |
| 99 | Loop Early Exit Pattern | return/exit from loop |
| 100 | Parallel Loop Jobs | `&` background + `wait` |

---

## Module 6 — Functions (20 levels) · Intermediate

> Defining functions, arguments, return values, local scope, recursion preview.

| Level | Title | Concept |
|---|---|---|
| 101 | Define a Function | `function_name() { }` |
| 102 | Call a Function | function invocation |
| 103 | Function Arguments | `$1 $2` inside function |
| 104 | Return Exit Code | `return N` |
| 105 | Capture Return Value | `$?` after call |
| 106 | Return a String | via echo + $() |
| 107 | Local Variables | `local var=value` |
| 108 | Default Argument in Function | `${1:-default}` |
| 109 | Validate Arguments in Function | guard clause pattern |
| 110 | Function Library | source a helper file |
| 111 | Recursive Function | factorial |
| 112 | Recursive Tree Walk | directory traversal |
| 113 | Function as Callback | passing function name |
| 114 | Functions in a Loop | repeated calls |
| 115 | Overriding a Function | redefining a function |
| 116 | Anonymous-Style Function | inline definition |
| 117 | Error-Handling Function | die() pattern |
| 118 | Log Function | log with timestamp |
| 119 | Function with Array Arg | passing arrays via nameref |
| 120 | Function Return Array | returning multiple values |

---

## Module 7 — String Manipulation (22 levels) · Intermediate

> All the string operations bash offers natively.

| Level | Title | Concept |
|---|---|---|
| 121 | String Length | `${#str}` |
| 122 | Substring | `${str:2:5}` |
| 123 | Substring from End | negative offset |
| 124 | Strip Shortest Prefix | `${str#pattern}` |
| 125 | Strip Longest Prefix | `${str##pattern}` |
| 126 | Strip Shortest Suffix | `${str%pattern}` |
| 127 | Strip Longest Suffix | `${str%%pattern}` |
| 128 | Replace First Match | `${str/old/new}` |
| 129 | Replace All Matches | `${str//old/new}` |
| 130 | Uppercase All | `${str^^}` |
| 131 | Lowercase All | `${str,,}` |
| 132 | Capitalize First Letter | `${str^}` |
| 133 | Trim Leading Whitespace | parameter expansion trick |
| 134 | Trim Trailing Whitespace | echo + sed or expansion |
| 135 | Trim Both Ends | combined trimming |
| 136 | Split String to Array | `IFS` split |
| 137 | Join Array to String | `IFS=,` join trick |
| 138 | Check Prefix | `[[ $str == prefix* ]]` |
| 139 | Check Suffix | `[[ $str == *suffix ]]` |
| 140 | Check Substring | `[[ $str == *sub* ]]` |
| 141 | Regex Match | `[[ $str =~ regex ]]` |
| 142 | Extract Regex Group | `${BASH_REMATCH[1]}` |

---

## Module 8 — Arithmetic (14 levels) · Intermediate

> Integer arithmetic, arithmetic expansion, and floating point via bc.

| Level | Title | Concept |
|---|---|---|
| 143 | Integer Addition | `$(( a + b ))` |
| 144 | Subtraction & Multiplication | `$(( a * b ))` |
| 145 | Division & Modulo | `$(( a / b ))`, `$(( a % b ))` |
| 146 | Power | `$(( base ** exp ))` |
| 147 | Increment / Decrement | `(( i++ ))`, `(( i-- ))` |
| 148 | Compound Assignment | `(( i += 5 ))` |
| 149 | let Command | `let "result = a * b"` |
| 150 | Arithmetic Condition | `(( a > b ))` as if condition |
| 151 | Float Arithmetic with bc | `echo "scale=2; 1/3" \| bc` |
| 152 | Random Number | `$RANDOM` |
| 153 | Random in Range | `$(( RANDOM % N ))` |
| 154 | Convert Bases | `printf "%x" 255` |
| 155 | Sum a List | loop accumulator |
| 156 | Min and Max | compare in loop |

---

## Module 9 — Arrays (22 levels) · Intermediate

> Indexed arrays, associative arrays, slicing, iteration.

| Level | Title | Concept |
|---|---|---|
| 157 | Declare an Array | `arr=(a b c)` |
| 158 | Access Element | `${arr[0]}` |
| 159 | All Elements | `${arr[@]}` |
| 160 | Array Length | `${#arr[@]}` |
| 161 | Append to Array | `arr+=(new)` |
| 162 | Remove Element | `unset arr[i]` |
| 163 | Slice an Array | `${arr[@]:start:len}` |
| 164 | Loop over Array | `for item in "${arr[@]}"` |
| 165 | Loop with Index | `for i in "${!arr[@]}"` |
| 166 | Array from Command | `mapfile -t arr < <(cmd)` |
| 167 | Array from File Lines | mapfile |
| 168 | Search in Array | loop + grep |
| 169 | Sort an Array | `readarray` + `sort` |
| 170 | Unique Elements | sort + uniq trick |
| 171 | Associative Array | `declare -A map` |
| 172 | Add Key-Value | `map[key]=value` |
| 173 | Iterate Assoc Array | `for k in "${!map[@]}"` |
| 174 | Check Key Exists | `[[ -v map[key] ]]` |
| 175 | Delete Key | `unset map[key]` |
| 176 | Pass Array to Function | nameref `declare -n` |
| 177 | Return Array from Function | output parsing |
| 178 | 2D Array Simulation | key encoding trick |

---

## Module 10 — Redirection & Pipelines in Scripts (18 levels) · Intermediate

> stdin/stdout/stderr, file descriptors, here-docs, process substitution.

| Level | Title | Concept |
|---|---|---|
| 179 | Redirect stdout to File | `>` and `>>` |
| 180 | Redirect stderr to File | `2>` |
| 181 | Redirect Both | `&>` |
| 182 | Redirect stderr to stdout | `2>&1` |
| 183 | Discard Output | `>/dev/null` |
| 184 | Read from File with Redirect | `cmd < file` |
| 185 | Here-Document | `<<EOF ... EOF` |
| 186 | Here-Document No Expand | `<<'EOF'` |
| 187 | Here-String | `cmd <<< "string"` |
| 188 | Pipe Between Commands | `cmd1 \| cmd2` |
| 189 | Pipeline Exit Code | `${PIPESTATUS[@]}` |
| 190 | Process Substitution Input | `cmd <(other_cmd)` |
| 191 | Process Substitution Output | `cmd >(other_cmd)` |
| 192 | Tee in Pipeline | `tee` for logging |
| 193 | Custom File Descriptor | `exec 3>file` |
| 194 | Close File Descriptor | `exec 3>&-` |
| 195 | Redirect in Function | function with fd |
| 196 | Log Everything with exec | `exec > >(tee logfile)` |

---

## Module 11 — Error Handling & Defensive Scripting (18 levels) · Intermediate

> exit codes, set -e/u/o pipefail, guard clauses, trap.

| Level | Title | Concept |
|---|---|---|
| 197 | Check Exit Code | `$?` after command |
| 198 | Exit on Failure | `cmd \|\| exit 1` |
| 199 | set -e | abort on error |
| 200 | set -u | abort on unset variable |
| 201 | set -o pipefail | catch pipe failures |
| 202 | Strict Mode Combo | `set -euo pipefail` |
| 203 | Trap on EXIT | cleanup always runs |
| 204 | Trap on ERR | log which command failed |
| 205 | Trap on SIGINT | graceful Ctrl-C |
| 206 | Trap on SIGTERM | handle kill signal |
| 207 | Cleanup Temp Files | trap + mktemp |
| 208 | die() Function | unified error exit |
| 209 | Guard Clause Pattern | early return on bad input |
| 210 | Retry on Failure | loop with counter |
| 211 | Timeout a Command | `timeout` command |
| 212 | Check Dependency Exists | `command -v` guard |
| 213 | Validate File Argument | must exist and be readable |
| 214 | Propagate Exit Codes | maintain exit code through functions |

---

## Module 12 — Regular Expressions in Bash (18 levels) · Intermediate

> Pattern matching with `[[ =~ ]]`, grep, sed, and BASH_REMATCH.

| Level | Title | Concept |
|---|---|---|
| 215 | Basic Regex Match | `[[ $str =~ pattern ]]` |
| 216 | Capture Group | `${BASH_REMATCH[1]}` |
| 217 | Multiple Groups | `${BASH_REMATCH[2]}` |
| 218 | Match a Number | `^[0-9]+$` |
| 219 | Match an Email | email regex pattern |
| 220 | Match an IP Address | IP regex pattern |
| 221 | Match a Date | YYYY-MM-DD regex |
| 222 | Anchors | `^` and `$` |
| 223 | Character Classes | `[a-z]`, `[[:alpha:]]` |
| 224 | Quantifiers | `*`, `+`, `?`, `{n,m}` |
| 225 | Alternation | `(foo\|bar)` |
| 226 | Non-Greedy in sed | `sed 's/a.*?b/X/'` (POSIX) |
| 227 | grep -E in Script | extended regex in scripts |
| 228 | grep -P in Script | Perl regex (where available) |
| 229 | sed Substitution in Script | `sed 's/old/new/'` |
| 230 | sed with Capture Group | `sed 's/\(.*\)/[\1]/'` |
| 231 | Validate and Extract | combined match + capture |
| 232 | Multi-line Regex Logic | line-by-line state machine |

---

## Module 13 — File Operations in Scripts (18 levels) · Intermediate

> Creating, reading, writing, copying, and manipulating files from scripts.

| Level | Title | Concept |
|---|---|---|
| 233 | Create a File | `touch`, `>` |
| 234 | Write to a File | echo redirect |
| 235 | Append to a File | `>>` |
| 236 | Read Entire File | `$(<file)` |
| 237 | Read Line by Line | `while IFS= read -r` |
| 238 | Read Specific Line | `sed -n '5p'` |
| 239 | Count Lines in File | `wc -l` |
| 240 | Copy a File | `cp` with error check |
| 241 | Move/Rename a File | `mv` |
| 242 | Delete Safely | check before delete |
| 243 | Create Temp File | `mktemp` |
| 244 | Create Temp Directory | `mktemp -d` |
| 245 | Find Files by Pattern | `find` in script |
| 246 | Find Files by Age | `find -mtime` |
| 247 | File Locking | `flock` |
| 248 | Atomic Write | write-then-move pattern |
| 249 | Backup Before Write | cp + write pattern |
| 250 | Parse CSV File | IFS split per line |

---

## Module 14 — Text Processing in Scripts (22 levels) · Intermediate→Advanced

> Using awk, sed, cut, sort, uniq, tr as script tools.

| Level | Title | Concept |
|---|---|---|
| 251 | Cut Columns | `cut -d, -f2` |
| 252 | Sort File | `sort` in script |
| 253 | Sort Numerically | `sort -n` |
| 254 | Unique Lines | `sort \| uniq` |
| 255 | Count Occurrences | `sort \| uniq -c \| sort -rn` |
| 256 | Translate Characters | `tr` |
| 257 | Delete Characters | `tr -d` |
| 258 | Squeeze Whitespace | `tr -s ' '` |
| 259 | awk Print Column | `awk '{print $2}'` |
| 260 | awk with Condition | `awk '$3 > 100'` |
| 261 | awk Sum Column | `awk '{sum+=$1} END{print sum}'` |
| 262 | awk Field Separator | `awk -F,` |
| 263 | awk Associative Array | frequency count |
| 264 | sed Delete Lines | `sed '/pattern/d'` |
| 265 | sed Print Line Range | `sed -n '5,10p'` |
| 266 | sed Multi-command | `-e` |
| 267 | sed In-Place Edit | `sed -i` |
| 268 | Join Two Files | `join`, `paste` |
| 269 | Column Alignment | `column -t` |
| 270 | Generate a Report | combine awk+sort+head |
| 271 | Parse Key=Value Config | while read + IFS |
| 272 | Transform JSON-like Text | extract values with grep/awk |

---

## Module 15 — Script Structure & Best Practices (18 levels) · Advanced

> Headers, strict mode, documentation, shellcheck habits, portability.

| Level | Title | Concept |
|---|---|---|
| 273 | Proper Shebang | `#!/usr/bin/env bash` |
| 274 | Script Header Block | name, author, usage, description |
| 275 | Usage Function | print_usage() with exit |
| 276 | Strict Mode Setup | `set -euo pipefail` + IFS |
| 277 | ShellCheck Clean Script | write shellcheck-clean code |
| 278 | Consistent Quoting | always quote variables |
| 279 | Avoid Word Splitting Bugs | `"$@"` not `$@` |
| 280 | Use Printf over Echo | portable output |
| 281 | Avoid Useless Cat | `< file` not `cat file \|` |
| 282 | Use Local Variables | prevent global leaks |
| 283 | Use Meaningful Names | naming conventions |
| 284 | DRY with Functions | no copy-pasted logic |
| 285 | Modular Script Layout | organize into sections |
| 286 | Configuration Section | top-of-script constants |
| 287 | Main Function Pattern | `main() { }; main "$@"` |
| 288 | Portable Bash | avoid bashisms where possible |
| 289 | POSIX sh vs bash | know when you need bash |
| 290 | Version Guard | check bash version |

---

## Module 16 — Debugging Scripts (14 levels) · Advanced

> set -x, PS4, bashdb techniques, tracing, and isolating bugs.

| Level | Title | Concept |
|---|---|---|
| 291 | set -x Trace | `set -x` |
| 292 | set -v Verbose | `set -v` |
| 293 | Custom PS4 | show file/line in trace |
| 294 | Trace a Subshell | `bash -x script.sh` |
| 295 | Trace Specific Block | `set -x; ...; set +x` |
| 296 | Debug Log Function | conditional `DEBUG` variable |
| 297 | LINENO in Errors | `$LINENO` |
| 298 | FUNCNAME Stack | `${FUNCNAME[@]}` |
| 299 | BASH_SOURCE | source file tracking |
| 300 | Trap ERR with Context | log command + line |
| 301 | Dry-Run Mode | `DRY_RUN=1` flag |
| 302 | Assert Function | assert_eq, assert_true |
| 303 | Test-Driven Bash | write tests for your function |
| 304 | Isolate Failing Command | binary search debug |

---

## Module 17 — Process Management in Scripts (18 levels) · Advanced

> Background jobs, wait, signals, subshells, job control from scripts.

| Level | Title | Concept |
|---|---|---|
| 305 | Run in Background | `cmd &` |
| 306 | Capture Background PID | `$!` |
| 307 | Wait for Background Job | `wait $pid` |
| 308 | Wait All Backgrounds | `wait` |
| 309 | Check Job Still Running | `kill -0 $pid` |
| 310 | Kill a Background Job | `kill $pid` |
| 311 | Parallel Jobs with Limit | N workers pattern |
| 312 | Subshell | `( ... )` |
| 313 | Subshell Variable Isolation | changes don't leak |
| 314 | Command Group | `{ ... }` |
| 315 | Process Substitution | `<(cmd)` |
| 316 | Named Pipe (FIFO) | `mkfifo` |
| 317 | Send Signal to Self | `kill -USR1 $$` |
| 318 | Handle SIGHUP | daemon-style script |
| 319 | nohup & disown | detach from terminal |
| 320 | xargs for Parallelism | `xargs -P N` |
| 321 | GNU Parallel Basics | `parallel` tool |
| 322 | Semaphore Pattern | limit concurrent jobs |

---

## Module 18 — Advanced Functions & Patterns (18 levels) · Advanced

> Higher-order patterns: dispatch tables, hooks, plugins, memoization.

| Level | Title | Concept |
|---|---|---|
| 323 | Dispatch Table | assoc array of function names |
| 324 | Plugin System | source files from a dir |
| 325 | Hook System | pre/post hook arrays |
| 326 | Memoize a Function | cache results in assoc array |
| 327 | Curry-Style Partial | factory functions |
| 328 | Decorator Pattern | wrap and extend a function |
| 329 | Function Exists Check | `declare -F func` |
| 330 | Dynamic Function Call | `"$func" args` |
| 331 | Variadic Functions | `"$@"` forwarding |
| 332 | Generator Pattern | function + global state |
| 333 | Iterator over File | closure-style read |
| 334 | Event Emitter | signal-driven pattern |
| 335 | Builder Pattern | chained config calls |
| 336 | Strategy Pattern | swap algorithm functions |
| 337 | Middleware Chain | pipeline of functions |
| 338 | Retry Decorator | wrap any command |
| 339 | Timeout Decorator | `timeout` wrapping |
| 340 | Audit Decorator | log all calls |

---

## Module 19 — Configuration & Environment (14 levels) · Advanced

> Config files, dotenv loading, environment variable management.

| Level | Title | Concept |
|---|---|---|
| 341 | Load dotenv File | parse `KEY=VALUE` into env |
| 342 | Config File with Defaults | layered config merging |
| 343 | Override via Env Var | `${VAR:-config_value}` |
| 344 | Validate Required Config | check all required vars |
| 345 | XDG Base Dirs | `$XDG_CONFIG_HOME` |
| 346 | Per-User Config | `~/.config/app/config` |
| 347 | Per-Project Config | walk up to find config |
| 348 | Config Schema Check | validate types, ranges |
| 349 | Secret Handling | never echo secrets |
| 350 | Masked Output | replace secret in logs |
| 351 | Dynamic Config Reload | trap SIGHUP to reload |
| 352 | Environment Report | print all config values |
| 353 | Config Migration | upgrade old format |
| 354 | Config Diff | compare two config files |

---

## Module 20 — Script Security (14 levels) · Advanced

> Injection prevention, safe file handling, privilege awareness.

| Level | Title | Concept |
|---|---|---|
| 355 | Quote to Prevent Injection | `"$var"` vs eval danger |
| 356 | Safe eval Usage | never eval user input |
| 357 | Sanitize User Input | strip dangerous chars |
| 358 | Safe Temp Files | mktemp, not predictable names |
| 359 | Restrict Permissions | umask in scripts |
| 360 | Avoid World-Writable | chmod after create |
| 361 | Check Running as Root | guard non-root scripts |
| 362 | Drop Privileges | `sudo -u` as target user |
| 363 | Secure PATH | reset PATH at script start |
| 364 | Avoid Parsing ls | use glob/find instead |
| 365 | Safe Directory Traversal | check symlinks |
| 366 | Prevent TOCTOU | atomic operations |
| 367 | Credential Scrubbing | clear vars after use |
| 368 | Log Sanitization | remove secrets from logs |

---

## Module 21 — Networking in Scripts (14 levels) · Advanced

> curl, wget, HTTP checks, API calls, retry logic, webhook scripts.

| Level | Title | Concept |
|---|---|---|
| 369 | HTTP GET with curl | `curl -s URL` |
| 370 | Check HTTP Status Code | `curl -o /dev/null -w "%{http_code}"` |
| 371 | POST with curl | `curl -X POST -d data` |
| 372 | JSON POST | `curl -H "Content-Type: application/json"` |
| 373 | Pass Auth Header | Bearer token |
| 374 | Handle curl Errors | `--fail` flag |
| 375 | Retry HTTP Request | loop with backoff |
| 376 | Parse JSON Response | `jq` in scripts |
| 377 | Extract Field from JSON | `jq -r '.field'` |
| 378 | Webhook Listener Stub | `nc` listener |
| 379 | Check Port Open | `nc -z host port` |
| 380 | DNS Lookup in Script | `dig`, `nslookup` |
| 381 | Download File Safely | verify checksum |
| 382 | Rate-Limited API Script | sleep between calls |

---

## Module 22 — Logging & Monitoring Scripts (18 levels) · Advanced

> Structured logging, log rotation, health checks, alerting scripts.

| Level | Title | Concept |
|---|---|---|
| 383 | Timestamped Log | `printf "[%s] %s\n" "$(date)" "$msg"` |
| 384 | Log Levels | DEBUG INFO WARN ERROR |
| 385 | Log to File and Stdout | `tee` |
| 386 | Log Rotation Stub | size check + mv |
| 387 | Syslog from Script | `logger` command |
| 388 | Health Check Script | check process, disk, memory |
| 389 | Disk Usage Alert | threshold + notification |
| 390 | CPU Load Check | `uptime` parse |
| 391 | Memory Usage Check | `free` parse |
| 392 | Process Alive Check | pidfile pattern |
| 393 | Heartbeat Script | periodic ping/log |
| 394 | Alert on Log Pattern | tail + grep + notify |
| 395 | Metrics Collector | gather stats to file |
| 396 | Dashboard Script | terminal status display |
| 397 | Watchdog Script | restart crashed process |
| 398 | On-Call Notification | curl to webhook on alert |
| 399 | Audit Trail | append every action |
| 400 | Summary Report Generator | aggregate daily stats |

---

## Module 23 — Automation & CI/CD Scripts (18 levels) · Advanced

> Deployment scripts, release management, CI helper scripts.

| Level | Title | Concept |
|---|---|---|
| 401 | Build Script | compile + test + report |
| 402 | Deploy Script | copy + restart + verify |
| 403 | Rollback Script | restore previous version |
| 404 | Health Check After Deploy | poll until healthy |
| 405 | Release Tag Script | git tag + push |
| 406 | Changelog Generator | git log formatting |
| 407 | Version Bumper | semver increment |
| 408 | Dependency Checker | check all tools installed |
| 409 | Lint Script | run linters, collect exit codes |
| 410 | Test Runner Script | run tests, parse output |
| 411 | Coverage Check | fail below threshold |
| 412 | Docker Build Script | build + tag + push |
| 413 | Kubernetes Apply Script | apply + wait + verify |
| 414 | Secret Injection Script | render template with secrets |
| 415 | Environment Promo Script | promote config between envs |
| 416 | Cron Wrapper Script | lock + log + notify |
| 417 | Idempotent Setup Script | check before create |
| 418 | Cleanup Script | remove old artifacts |

---

## Module 24 — Data Processing Scripts (18 levels) · Advanced

> CSV, JSON, log parsing, report generation, data transformation.

| Level | Title | Concept |
|---|---|---|
| 419 | Parse CSV | IFS + while read |
| 420 | Validate CSV Schema | check column count |
| 421 | Filter CSV Rows | awk condition |
| 422 | Transform CSV Columns | awk reorder |
| 423 | Aggregate CSV Column | sum/avg/min/max |
| 424 | Join Two CSVs | join on key |
| 425 | Convert CSV to JSON | awk JSON output |
| 426 | Parse Log File | extract fields by regex |
| 427 | Count Log Events | frequency table |
| 428 | Top N from Log | sort + head |
| 429 | Time-Range Filter | compare timestamps |
| 430 | Pivot Table in Bash | assoc array aggregation |
| 431 | Generate HTML Report | heredoc HTML |
| 432 | Generate Markdown Report | dynamic tables |
| 433 | Diff Two Data Sets | comm or diff |
| 434 | Deduplicate Records | sort -u on key |
| 435 | Merge Files by Key | multi-file join |
| 436 | Streaming Transform | process line by line, no temp file |

---

## Module 25 — System Automation Scripts (20 levels) · Expert

> Real sysadmin-level scripts: backups, user management, system hardening.

| Level | Title | Concept |
|---|---|---|
| 437 | Backup Script | rsync + timestamp + retention |
| 438 | Incremental Backup | rsync --link-dest |
| 439 | Restore Verification | checksum comparison |
| 440 | User Provisioning Script | create users from CSV |
| 441 | User Deprovisioning Script | lock + archive home |
| 442 | SSH Key Distributor | push keys to multiple hosts |
| 443 | Multi-Host Executor | run command on host list |
| 444 | Config Distributor | rsync config to servers |
| 445 | Certificate Expiry Checker | parse openssl output |
| 446 | Log Archiver | compress + move old logs |
| 447 | Disk Cleanup Script | remove old files by age/size |
| 448 | Package Audit Script | list installed, flag outdated |
| 449 | Service Restart Orchestrator | rolling restart |
| 450 | Database Dump Script | dump + compress + verify |
| 451 | Port Scanner Script | nc loop over ports |
| 452 | SSL Checker Script | verify cert chain |
| 453 | Firewall Audit Script | parse iptables output |
| 454 | Hardening Checklist Script | check security settings |
| 455 | Compliance Report Script | gather evidence, write report |
| 456 | Incident Response Script | collect forensic data |

---

## Module 26 — War Games: Mega Scripts (44 levels) · Expert

> Multi-step, real-world automation challenges. Each mission requires  
> combining 5+ concepts into a production-quality script.

| Level | Title | Mission Summary |
|---|---|---|
| 457 | The Deployment Pipeline | Build → test → deploy → verify → rollback on failure |
| 458 | The Log Investigator | Parse multi-format logs, extract incidents, generate report |
| 459 | The Secret Rotator | Rotate credentials, update configs, verify services |
| 460 | The Capacity Planner | Collect disk/CPU/mem trends, project growth, alert |
| 461 | The User Auditor | Find orphan users, stale accounts, bad permissions |
| 462 | The API Poller | Poll API, detect state changes, trigger webhooks |
| 463 | The Backup Verifier | Restore + checksum every backup in retention window |
| 464 | The Cron Analyzer | Parse crontabs across users, find conflicts, report |
| 465 | The Config Drift Detector | Compare live config vs golden config, flag diffs |
| 466 | The Release Manager | Tag, changelog, build, upload artifacts, notify |
| 467 | The Certificate Watchdog | Check all certs, alert on expiry, auto-renew stub |
| 468 | The Service Health Dashboard | Multi-service status in terminal, auto-refresh |
| 469 | The Incident Responder | Collect system state snapshot on alert trigger |
| 470 | The Multi-Env Deployer | Deploy to dev/staging/prod with promotion gates |
| 471 | The Data Pipeline | Ingest CSV, validate, transform, load, report |
| 472 | The Test Harness Builder | Framework: register + run + report test cases |
| 473 | The Plugin System | Core + plugin discovery + execution |
| 474 | The CLI Framework | Subcommands, flags, help, version |
| 475 | The Config Manager | Load, validate, merge, export config |
| 476 | The Job Queue | FIFO queue with worker pool |
| 477 | The Audit Logger | Tamper-evident append-only log |
| 478 | The Self-Updating Script | Download + verify + replace self |
| 479 | The Distributed Lock | flock across shared filesystem |
| 480 | The Rate Limiter | Token bucket in bash |
| 481 | The Circuit Breaker | State machine for API calls |
| 482 | The Feature Flag System | Config-driven feature toggling |
| 483 | The Blue-Green Switcher | Atomic traffic switch between deployments |
| 484 | The Canary Releaser | Gradual traffic shift + monitor |
| 485 | The Chaos Monkey | Random fault injection for resilience testing |
| 486 | The SLA Monitor | Track uptime, calculate SLA %, generate report |
| 487 | The Cost Analyzer | Aggregate resource usage, estimate costs |
| 488 | The Security Scanner | Find misconfigs, world-writable files, weak perms |
| 489 | The Forensics Collector | Preserve evidence: processes, connections, files |
| 490 | The Self-Healing Script | Monitor + detect + auto-remediate |
| 491 | The Dependency Graph | Build task DAG, execute in order |
| 492 | The Template Engine | Variable substitution in text templates |
| 493 | The State Machine | Enum states, transitions, validation |
| 494 | The Event Bus | Pub/sub via named pipes |
| 495 | The Retry Framework | Configurable retry with strategies |
| 496 | The Observability Kit | Metrics + logs + traces in bash |
| 497 | The Compliance Enforcer | Apply and verify policy rules |
| 498 | The Migration Runner | Ordered idempotent migration scripts |
| 499 | The Ultimate Deployer | Full GitOps-style deploy pipeline |
| 500 | The Grand Finale | Design and implement a complete sysadmin automation suite |

---

## Difficulty Summary

| Difficulty | Levels | Modules |
|---|---|---|
| Beginner | 160 | 1–5 (levels 1–100) + module 6 partial |
| Intermediate | 175 | Modules 6–13 (levels 101–250) |
| Advanced | 140 | Modules 14–24 (levels 251–436) |
| Expert | 25 | Modules 25–26 (levels 437–500) |
| **Total** | **500** | **26 modules** |
