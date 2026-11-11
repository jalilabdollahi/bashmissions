# Writing BashMissions Levels

This is the contract every level must meet. `scripts/validate_levels.py` enforces
the mechanical parts; the rest is judged by a human reviewer.

## 1. Who we write for

The player knows the basics of a terminal (cd, ls, running a command) and maybe
a little Bash. They are **not** a professional. The game must make them
measurably better, one small step at a time, and it must be fun.

- **One new idea per level.** Each level teaches exactly the concept in its
  curriculum row. Everything else it uses must come from earlier levels.
- **Climb inside each module.** The first level of a module is gentle; the last
  one combines the module's ideas.
- **Real tasks, not puzzles about syntax.** Every level is a small job someone
  at Lanternfish actually needs done.
- **Never two alike.** No shared paragraphs, no shared hint text, no "same
  script with a different name". Different data, different scene, different
  output format. The validator flags anything over ~85% similar.

## 2. The world: Lanternfish Hosting

The player is the newest operations engineer at **Lanternfish Hosting**, a
small hosting company in a harbour town. Light, warm, slightly funny tone.
Never cringe, never long.

Recurring cast (use whoever fits; don't force them in):

| Name | Role | Flavour |
|---|---|---|
| Mara | senior SRE, the player's mentor | calm, precise, loves a clean script |
| Theo | backend developer | ships fast, breaks things, means well |
| Priya | security lead | paranoid for a living, dry humour |
| Gus | CFO / co-founder | wants numbers and reports, hates surprises |
| Noor | support desk | forwards customer problems, very organised |
| Ollie | intern | asks the questions the player is too shy to ask |

Servers are named after sea creatures (`anchovy`, `barracuda`, `cuttlefish`,
`dory`, `eel`, `flounder`, `grouper`, `halibut`, `marlin`, `octopus`, ...).
Customers are local businesses (Harbour Bakery, Tidewater Books, Gull & Anchor
Pub, North Pier Dental, ...). Invent freely, keep it consistent.

## 3. Files in a level directory

`modules/module-NN-<module-slug>/level-NNN-<title-slug>/`
(level number zero-padded to 3 digits, title slug = lowercase title, non
alphanumerics turned into `-`).

| File | Purpose |
|---|---|
| `mission.yaml` | metadata, story, objective, tests |
| `solution.sh` | the **starter** the player edits; must FAIL the tests |
| `answer.sh` | reference solution; must PASS the tests |
| `hint-1.txt` `hint-2.txt` `hint-3.txt` | escalating hints |
| `solution-guide.md` | full walkthrough (`guide` command) |
| `debrief.md` | the lesson shown after passing |
| `common-mistakes.md` | shown after the debrief |
| `fixtures/` | optional input files, copied to `fixtures/` in the run dir |
| `stubs/` | optional fake commands, put first on `PATH` (see §6) |
| `check.sh` | optional extra verifier (see §7) |

### mission.yaml

```yaml
id: 131
module: 7
module_name: string-manipulation            # module dir name without "module-07-"
module_display: String Surgery              # from CURRICULUM.md
title: UPPER and lower                      # exactly the curriculum title
difficulty: intermediate                    # beginner|intermediate|advanced|expert
xp: 120
story: |
  Noor forwards a ticket: Harbour Bakery typed their domain as "HarbourBakery.COM"
  and the DNS tool choked. Mara wants every hostname normalised before it reaches
  the DNS tool, and every customer code shouted in capitals for the billing export.
objective: |
  Write solution.sh that takes two arguments: a hostname and a customer code.
  Print two lines:
    host=<hostname in lowercase>
    code=<customer code in UPPERCASE>
  If either argument is missing, print "usage: solution.sh HOSTNAME CODE"
  to stderr and exit with status 2.
  Use Bash parameter expansion, not tr or awk.
concepts:
  - "${var,,} lowercase"
  - "${var^^} uppercase"
required_patterns:                          # optional technique checks
  - pattern: '\$\{[A-Za-z_][A-Za-z0-9_]*,,\}'
    message: "Lowercase the hostname with ${var,,}."
  - pattern: '\$\{[A-Za-z_][A-Za-z0-9_]*\^\^\}'
    message: "Uppercase the customer code with ${var^^}."
forbidden_patterns:
  - pattern: '\btr\b'
    message: "This level is about parameter expansion; leave tr for later."
test_cases:
  - name: mixed case domain
    args: [HarbourBakery.COM, hb-042]
    expected_stdout: |-
      host=harbourbakery.com
      code=HB-042
  - name: already clean
    args: [tidewater.example, TWB-7]
    expected_stdout: |-
      host=tidewater.example
      code=TWB-7
  - name: missing code is an error
    args: [gull.example]
    expected_stderr: "usage: solution.sh HOSTNAME CODE"
    expected_exit: 2
```

Test-case keys: `name` (required, unique), `args`, `stdin` (string fed on
stdin; default is no input / EOF), `env` (map of extra environment
variables), `files` (map `path: content` created before the run; content may
also be `{content: ..., mode: "0600", mtime: 1700000000}`; a path ending in
`/` with an empty value, e.g. `"archive/": ""`, creates an empty directory), `expected_stdout`,
`expected_stderr`, `expected_exit` (default 0), `comparison` and
`stderr_comparison` (`exact` default, `contains`, `ignore_whitespace`,
`regex` = Python `re.fullmatch`), `expected_files` (map `path: content`; `true`
= must exist; `null` = must not exist).

Other level keys: `required_patterns` / `forbidden_patterns` (regex on the
script with full-line comments removed), `timeout` (seconds, default 5, max
15), `single_case: true` (only when the output is genuinely fixed, e.g.
level 1), `fixtures` (informational list).

Trailing newlines of stdout/stderr/files are ignored when comparing.
Use YAML block scalars (`|-`) for multi-line expected output.

### Test design rules

- **At least 3 cases** for most levels (minimum 2). Vary the inputs so that
  printing a hard-coded answer fails. Include at least one edge case (empty
  input, spaces in names, missing argument, zero, a file that does not exist).
- If the level teaches a technique, add a `required_patterns` rule so the
  player cannot pass by side-stepping it. Messages must be friendly and say
  what to use.
- Expected output must be **deterministic**: no current dates, PIDs, random
  numbers or absolute paths in exact comparisons. Use `regex` comparison for
  those, or have the script take the date/seed as input.
- The objective must specify everything the tests check: exact output format,
  exit codes, where messages go (stdout vs stderr). A player who follows the
  objective literally must pass. No hidden surprises.

## 4. Writing each text file

**story** (2–4 sentences): the scene. Who asks, why it matters. Vary
openings — not every story starts with "Mara pings you". No instructions here.

**objective**: the precise spec, written to the player ("Write solution.sh
that ..."). Inputs, outputs (show the exact format), exit codes, constraints.

**hint-1.txt**: a nudge in plain words. Which idea to reach for, no syntax.
**hint-2.txt**: the specific syntax/tool, with a tiny *generic* example that is
not the solution.
**hint-3.txt**: an almost-solution: the skeleton or the key line with the
level's own variable names, leaving a little for the player to finish.

**solution.sh** (starter): shebang, a 2–4 line comment restating the task in
this level's terms, and TODO comments that sketch the steps for this
particular task. Early modules may include a bit of scaffolding (e.g. the
argument check is already there). It must not pass the tests. Never copy the
answer in.

**answer.sh**: idiomatic, readable, commented where a learner would wonder
"why?". Uses the level's concept the way a professional would. From module 3
on use `set -euo pipefail` unless the level is about something that conflicts
with it (then explain why in a comment).

**solution-guide.md** (300–700 words): `# Walkthrough: <title>` then: the
plan in plain words; step-by-step building of the script with short code
snippets; the complete solution; how to try it by hand in the workspace
(`./solution.sh ...`); one alternative approach and why the main one is
preferred.

**debrief.md** (150–350 words): `# Debrief: <title>` then: what you just
learned (the mental model, not a repeat of the steps); how it works under the
hood; where it shows up in real work; a "Going further" tip that points
toward a later level's idea.

**common-mistakes.md**: `# Common Mistakes` then 3–5 bullets **specific to
this level's concept**, each with a wrong and a right snippet or a concrete
symptom. Never generic advice like "quote your variables" unless quoting is
the topic.

## 5. The test environment

Each test case runs in a fresh temporary directory containing `solution.sh`,
`fixtures/` (copied from the level) and any `files`. The run uses:

- Bash ≥ 4 (bash 5 in practice), started as `bash solution.sh ARGS...`
- `HOME` = a fresh empty folder inside the run dir, `TMPDIR` likewise
- `USER=player`, `LC_ALL=C`, `LANG=C`, `TZ=UTC`, `TERM=dumb`
- `PATH` = `./.bm-bin` (stubs) : bash's folder : `/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin`
- stdin = the `stdin` string, or empty (EOF) if not given
- wall-clock timeout 5 s (level `timeout` to raise), whole process group killed

`{RUN_DIR}` and `{HOME}` inside `env` values are replaced with the real paths.

## 6. Portability (macOS and Linux)

Levels must pass on macOS (BSD tools) **and** Linux (GNU tools, e.g. Debian
slim). Allowed external commands: `cat cp mv rm mkdir rmdir ln ls touch chmod
head tail wc sort uniq cut tr paste join comm diff cmp grep sed awk find
xargs basename dirname mktemp printf seq sleep kill tee tar gzip gunzip
cksum od expr env id uname date(+FORMAT only) mkfifo nohup true false test
yes rev fold nl split`. Everything else is a stub.

Rules (the validator checks most):

- `sed -i.bak` (with suffix), never bare `sed -i`. No GNU sed extensions
  (`\+` in BRE, `I` flag, `e`); prefer `sed -E`.
- `grep -E`, never `grep -P`.
- `awk`: POSIX only (no `gensub`, `strftime`, `asort`, `systime`, `length(arr)`
  is fine).
- `wc -l < file` pads with spaces on macOS: wrap with `$(( $(wc -l < f) ))`
  or `tr -d ' '`.
- No `stat -c/-f`, `date -d/-j`, `readlink -f`, `find -printf`, `tac`,
  `column`, `jq`, `timeout`, `flock`, `sha256sum`/`shasum`/`md5sum` (use
  `cksum`), `sort -h`, `xargs -r`.
- Permissions: test with `[[ -r ]]`, `find -perm`, or `ls -l` parsing; mtime
  via `find -newer` / `touch -t YYYYMMDDhhmm`.
- Anything host- or network-specific (`curl`, `nc`, `dig`, `git`, `docker`,
  `ssh`, `systemctl`, `logger`, `useradd`, `df`, `uptime`, `ps`, `openssl`,
  ...) is replaced by a **stub** in `stubs/`.

If a flagged line is genuinely fine, add a trailing `# portable-ok` comment.

## 7. Stubs and check.sh

**Stubs** (`stubs/<command>`) are small Bash scripts (`#!/usr/bin/env bash`)
that imitate a real tool just enough for the level. They:
- accept the flags the level teaches and fail loudly (exit 2, message on
  stderr) on flags they do not understand, so the player learns real usage;
- are deterministic; behaviour can be switched per test with env variables
  (e.g. `FAKE_HTTP_STATUS=503`) or with files in the run dir;
- may record their calls (append to `.calls.log` in the current dir) so
  tests can check what was called via `expected_files` or `check.sh`.

**check.sh** runs after the player's script only if all declarative checks
passed. It runs in the same dir with env `BM_STDOUT_FILE`, `BM_STDERR_FILE`,
`BM_EXIT`, `BM_TEST_NAME`, plus the test's args. Exit 0 = pass; anything it
prints is shown to the player as the reason. Use it only when declarative
checks cannot express the requirement (file permissions, call order...).

## 8. Process for an agent rewriting a module

1. Read this file and your module's section in `CURRICULUM.md`. Skim the
   previous module's level titles to know what the player already knows.
2. Delete the old level folders of your module (only yours!) and create the
   new ones. Keep the module directory name listed in the curriculum.
3. For each level write all files (§3–§4). Write it fresh; never generate
   levels from a shared template string.
4. Validate often: `.venv/bin/python scripts/validate_levels.py --level N --verbose`
   and at the end `.venv/bin/python scripts/validate_levels.py --module M`.
   It must print `X/X levels clean.`
5. Do not touch other modules, the engine, `levels.json`, or git.
