# BashMissions

![platform](https://img.shields.io/badge/platform-Linux%20%7C%20macOS-blue)
![shell](https://img.shields.io/badge/shell-bash-brightgreen)
![focus](https://img.shields.io/badge/learning-terminal%20scripting-orange)

> **Learn Bash by writing scripts, testing them, and understanding why they work.**

BashMissions is a fully local terminal game for learning Bash scripting through short, progressive coding challenges. Each level gives you a real scripting task, a sandboxed workspace, automated tests, hints, a walkthrough, a reference answer, and a post-level lesson.

**500 progressive levels across 26 modules — beginner to expert.**  
No cloud. No accounts. No external services required.

**Design and implementation by: Jalil Abdollahi**  
Email: `jalil.abdollahi@gmail.com`

---

## Features

- **500 levels** across 26 modules covering Bash fundamentals through advanced scripting
- **Rich terminal UI** with compact progress views, mission briefings, and clean code display
- **Progressive hints** that escalate into a walkthrough and reference answer when needed
- **Per-level teaching content** including `debrief.md`, `common-mistakes.md`, and `solution-guide.md`
- **General Bash handbook** via `guide bash` for beginners who need a broader explanation
- **XP and progression system** with auto-save and module certificates
- **Sandboxed workspace** under `/tmp/bashmissions/...` so learners can experiment safely
- **Watch mode** that reruns validation automatically while you work
- **Reset support** for both the current level and full game progress
- **Local-first** workflow with no browser dependency required

---

## Quick Start

```bash
cd /home/fatemeh/Desktop/AI-Projects/bashmissions
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
├── progress.json           # Saved progress
├── levels.json             # Built level registry
├── engine/
│   ├── engine.py           # Main game loop
│   ├── ui.py               # Rich terminal UI
│   ├── player.py           # Progress persistence
│   ├── runner.py           # Sandbox setup and test execution
│   ├── validator.py        # Output validation helpers
│   └── certificate.py      # Module certificate rendering
├── scripts/
│   ├── generate_curriculum.py
│   ├── generate_levels.py
│   └── ...
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
    │       ├── solution.sh
    │       └── fixtures/
    └── ...
```

---

## Regenerating Content

The level content is generated from the curriculum and scripts:

```bash
python3 scripts/generate_curriculum.py
python3 scripts/generate_levels.py
```

If you change the curriculum or generator logic, rerun both.

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
