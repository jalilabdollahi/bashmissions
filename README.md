# BashMissions

![platform](https://img.shields.io/badge/platform-Linux%20%7C%20macOS-blue)
![shell](https://img.shields.io/badge/shell-bash-brightgreen)
![focus](https://img.shields.io/badge/learning-terminal%20scripting-orange)

> **Learn Bash by writing scripts, testing them, and understanding why they work.**

BashMissions is a fully local terminal game for learning Bash scripting through short, progressive coding challenges. You play the newest operations engineer at **Lanternfish Hosting**; every level is a real task from a colleague, with a sandboxed workspace, automated tests, hints, a walkthrough, a reference answer, and a post-level lesson.

**500 progressive levels across 26 modules — from "I know a few commands" to "I automate production".**  
No cloud. No accounts. No external services required.

**Design and implementation by: Jalil Abdollahi**  
Email: `jalil.abdollahi@gmail.com`

---

## Features

- **500 hand-written levels** across 26 modules, each teaching one new idea inside a small story
- **Rich terminal UI** with compact progress views, mission briefings, and clean code display
- **Progressive hints** that escalate into a walkthrough and reference answer when needed
- **Per-level teaching content** including `debrief.md`, `common-mistakes.md`, and `solution-guide.md`
- **General Bash handbook** via `guide bash` for beginners who need a broader explanation
- **XP and progression system** with auto-save and module certificates
- **Sandboxed workspace** under `/tmp/bashmissions/...` so learners can experiment safely
- **Isolated test runs**: every test case runs in a fresh directory with a clean environment, so results are reproducible
- **Works on macOS and Linux** (fake `curl`, `git`, `docker`, ... stubs keep network/system levels offline and deterministic)
- **Watch mode** that reruns validation automatically while you work
- **Reset support** for both the current level and full game progress
- **Local-first** workflow with no browser dependency required

---

## Requirements

- Python 3.9+
- **Bash 4 or newer** for running missions. macOS ships Bash 3.2, so install a modern one first:
  `brew install bash` (the game finds it automatically; or set `BASHMISSIONS_BASH=/path/to/bash`)

## Quick Start

```bash
cd bashmissions
./install.sh
./play.sh
```

To reset all progress:

```bash
./play.sh --reset
```

---

## How to Play

1. Run `./play.sh`
2. Read the mission briefing
3. Open `solution.sh` and write your script
4. Run `check` or press `1`
5. If stuck, use `hint`, `guide`, or `answer`
6. Pass the tests, earn XP, and unlock the next level

---

## Commands

| Command | Shortcut | Description |
|---------|----------|-------------|
| `check` | `1` | Run the tests for the current level |
| `watch` | `2` | Auto-run validation every few seconds |
| `edit` | `3` | Open `solution.sh` in your editor |
| `show` | `4` | Show your current code |
| `hint` | `5` | Reveal the next hint |
| `mission` | `6` | Re-read the current mission |
| `reset` | `7` | Reset the current level workspace |
| `skip` | `8` | Skip the level without earning XP |
| `status` | `9` | Show compact progress |
| `status full` | — | Show the full campaign map |
| `guide` | — | Show the level walkthrough |
| `answer` | — | Reveal the reference solution |
| `guide bash` | — | Open the general Bash beginner handbook |
| `ls` | — | Show workspace files for the current level |
| `help` | `?` | Show the command reference |
| `quit` | `0` | Save and exit |

---

## Beginner-Friendly Learning Flow

BashMissions is designed to support different levels of confidence:

- `hint` gives small nudges
- `guide` gives a step-by-step walkthrough
- `answer` reveals a working reference solution
- `guide bash` opens a general Bash handbook covering variables, quoting, parameters, strings, conditions, loops, functions, files, pipes, and exit codes

This means a learner never has to get permanently stuck on a level.

---

## Learning Path

The game covers 26 modules, including:

- Hello World and output
- Variables and data types
- Arguments and input
- Conditionals
- Loops
- Functions
- Strings
- Arithmetic
- Arrays
- Redirection and pipelines
- Error handling
- Regular expressions
- File operations
- Text processing
- Debugging
- Process management
- Environment and configuration
- Security
- Networking
- Logging and monitoring
- Automation and CI/CD
- Data processing
- War-game style advanced scripting

---

## Project Structure

```text
bashmissions/
├── play.sh                 # Launch the game
├── install.sh              # One-time setup
├── BASH_GUIDE.md           # General Bash handbook for beginners
├── requirements.txt        # Python dependencies
├── CURRICULUM.md           # The 500-level plan
├── docs/AUTHORING.md       # Contract for writing a level
├── progress.json           # Saved progress (local, not in git)
├── levels.json             # Built level registry
├── engine/
│   ├── engine.py           # Main game loop
│   ├── ui.py               # Rich terminal UI
│   ├── player.py           # Progress persistence
│   ├── runner.py           # Sandbox setup and isolated test execution
│   ├── bashfind.py         # Locates a Bash 4+ interpreter
│   ├── safety.py           # Blocks obviously destructive scripts
│   ├── validator.py        # Output comparison helpers
│   └── certificate.py      # Module certificate rendering
├── scripts/
│   ├── generate_levels.py  # Builds levels.json from mission.yaml files
│   ├── validate_levels.py  # Quality gate for every level
│   └── test-linux.sh       # Runs the validator in a Debian container
└── modules/
    ├── module-01-.../
    │   └── level-001-.../
    │       ├── mission.yaml
    │       ├── hint-1.txt
    │       ├── hint-2.txt
    │       ├── hint-3.txt
    │       ├── debrief.md
    │       ├── common-mistakes.md
    │       ├── solution-guide.md
    │       ├── answer.sh
    │       ├── solution.sh     # starter given to the player
    │       ├── fixtures/       # optional input files
    │       └── stubs/          # optional fake commands (curl, git, ...)
    └── ...
```

---

## Writing and Checking Levels

Levels are written by hand following [docs/AUTHORING.md](docs/AUTHORING.md). After editing:

```bash
.venv/bin/python scripts/validate_levels.py --module 7   # or --level 131, or --all
scripts/test-linux.sh --module 7 --no-uniqueness         # same checks on Linux (Docker)
.venv/bin/python scripts/generate_levels.py              # rebuild levels.json
```

The validator runs each reference answer (must pass), each starter script (must fail),
checks portability rules, and flags levels whose texts or answers are too similar.

---

## Post-Level Learning

After completing a level, BashMissions can show:

- a victory panel
- a lesson debrief
- common mistakes for that level

This keeps the game focused on learning, not just passing tests.

---

## License

MIT License. See [LICENSE](LICENSE).
