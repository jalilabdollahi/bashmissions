"""Rich terminal UI for BashMissions — modelled after k8smissions."""
from __future__ import annotations

from pathlib import Path

from rich import box
from rich.console import Console, Group
from rich.markdown import Markdown
from rich.panel import Panel
from rich.rule import Rule
from rich.syntax import Syntax
from rich.table import Table
from rich.text import Text
from rich.tree import Tree

try:
    import select
    import termios
    import tty
    _WINDOWS = False
except ImportError:
    _WINDOWS = True

console = Console()

# ─────────────────────────────────────────────────────────────────────────────
# Constants
# ─────────────────────────────────────────────────────────────────────────────

DIFFICULTY_STARS = {
    "beginner":     "★☆☆☆☆",
    "intermediate": "★★★☆☆",
    "advanced":     "★★★★☆",
    "expert":       "★★★★★",
}

DIFFICULTY_COLOR = {
    "beginner":     "bright_green",
    "intermediate": "bright_yellow",
    "advanced":     "magenta",
    "expert":       "bright_red",
}

MODULE_DISPLAY = {
    1:  "Hello World & Output",
    2:  "Variables & Data Types",
    3:  "Arguments & Input",
    4:  "Conditionals",
    5:  "Loops",
    6:  "Functions",
    7:  "String Manipulation",
    8:  "Arithmetic",
    9:  "Arrays",
    10: "Redirection & Pipelines",
    11: "Error Handling",
    12: "Regular Expressions",
    13: "File Operations",
    14: "Text Processing",
    15: "Script Structure",
    16: "Debugging",
    17: "Process Management",
    18: "Advanced Functions",
    19: "Configuration & Env",
    20: "Script Security",
    21: "Networking",
    22: "Logging & Monitoring",
    23: "Automation & CI/CD",
    24: "Data Processing",
    25: "System Automation",
    26: "War Games",
}

_ASCII_LOGO = """\
 ██████╗  █████╗ ███████╗██╗  ██╗    ███╗   ███╗██╗███████╗███████╗██╗ ██████╗ ███╗   ██╗███████╗
 ██╔══██╗██╔══██╗██╔════╝██║  ██║    ████╗ ████║██║██╔════╝██╔════╝██║██╔═══██╗████╗  ██║██╔════╝
 ██████╔╝███████║███████╗███████║    ██╔████╔██║██║███████╗███████╗██║██║   ██║██╔██╗ ██║███████╗
 ██╔══██╗██╔══██║╚════██║██╔══██║    ██║╚██╔╝██║██║╚════██║╚════██║██║██║   ██║██║╚██╗██║╚════██║
 ██████╔╝██║  ██║███████║██║  ██║    ██║ ╚═╝ ██║██║███████║███████║██║╚██████╔╝██║ ╚████║███████║
 ╚═════╝ ╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝   ╚═╝     ╚═╝╚═╝╚══════╝╚══════╝╚═╝ ╚═════╝ ╚═╝  ╚═══╝╚══════╝"""

_ASCII_LOGO_COMPACT = """\
 ██████╗  █████╗ ███████╗██╗  ██╗
 ██╔══██╗██╔══██╗██╔════╝██║  ██║
 ██████╔╝███████║███████╗███████║
 ██╔══██╗██╔══██║╚════██║██╔══██║
 ██████╔╝██║  ██║███████║██║  ██║
 ╚═════╝ ╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝"""


def _logo_text() -> Text:
    try:
        width = console.size.width
    except Exception:
        width = 80
    if width >= 102:
        return Text(_ASCII_LOGO, style="bold bright_cyan")
    logo = Text()
    logo.append(_ASCII_LOGO_COMPACT, style="bold bright_cyan")
    logo.append("  MISSIONS", style="bold bright_magenta")
    return logo


# ─────────────────────────────────────────────────────────────────────────────
# Welcome screen  (shown on every startup after name is set)
# ─────────────────────────────────────────────────────────────────────────────

def show_welcome(player_name: str, total_xp: int, levels: list[dict], progress: dict) -> None:
    logo     = _logo_text()
    subtitle = Text("  500 challenges  •  26 modules  •  Real bash scripting", style="grey70")
    author   = Text("  Design and implementation by: Jalil Abdollahi", style="bold white")
    contact  = Text("  jalil.abdollahi@gmail.com", style="bright_magenta")
    agent    = Text.assemble(
        ("  Hacker : ", "grey70"),
        (player_name or "Unknown", "bold bright_magenta"),
        ("    XP : ", "grey70"),
        (f"{total_xp:,}", "bold bright_magenta"),
    )
    body = Group(logo, Text(""), author, contact, Text(""), subtitle, Text(""), agent)
    console.print(Panel(body, border_style="bright_cyan", box=box.ROUNDED, padding=(1, 2)))
    _show_compact_progress(levels, progress)
    console.print()


def _show_module_progress(levels: list[dict], progress: dict) -> None:
    completed_ids = set(progress.get("completed_levels", []))

    by_module: dict[int, list[dict]] = {}
    for lvl in levels:
        by_module.setdefault(lvl["module"], []).append(lvl)

    table = Table(box=box.SIMPLE_HEAVY, expand=True, show_header=True, header_style="bold bright_cyan")
    table.add_column("#",       style="grey50",      width=4)
    table.add_column("Module",  style="bright_cyan", ratio=3)
    table.add_column("Progress", style="white",      width=14)
    table.add_column("Done",    justify="right",     width=8)
    table.add_column("XP",      justify="right",     style="bright_magenta", width=14)

    for mod_id in sorted(by_module):
        mod_levels = by_module[mod_id]
        done       = sum(1 for l in mod_levels if l["id"] in completed_ids)
        total      = len(mod_levels)
        mod_xp     = sum(l.get("xp", 0) for l in mod_levels if l["id"] in completed_ids)
        max_xp     = sum(l.get("xp", 0) for l in mod_levels)
        name       = MODULE_DISPLAY.get(mod_id, f"Module {mod_id}")
        pct        = done / total if total else 0
        filled     = int(pct * 12)
        bar        = f"[bright_green]{'█' * filled}[/bright_green][grey30]{'░' * (12 - filled)}[/grey30]"
        done_style = "bright_green" if done == total else ("bright_yellow" if done > 0 else "grey50")

        table.add_row(
            str(mod_id),
            name,
            bar,
            f"[{done_style}]{done}/{total}[/{done_style}]",
            f"{mod_xp:,} / {max_xp:,}",
        )

    console.print(table)


def _module_rows(levels: list[dict], progress: dict) -> list[dict]:
    completed_ids = set(progress.get("completed_levels", []))
    current_mod = int(progress.get("current_module", 1) or 1)

    by_module: dict[int, list[dict]] = {}
    for lvl in levels:
        by_module.setdefault(lvl["module"], []).append(lvl)

    rows: list[dict] = []
    for mod_id in sorted(by_module):
        mod_levels = by_module[mod_id]
        done = sum(1 for lvl in mod_levels if lvl["id"] in completed_ids)
        total = len(mod_levels)
        max_xp = sum(lvl.get("xp", 0) for lvl in mod_levels)
        mod_xp = sum(lvl.get("xp", 0) for lvl in mod_levels if lvl["id"] in completed_ids)
        pct = done / total if total else 0
        filled = int(pct * 10)
        rows.append({
            "id": mod_id,
            "name": MODULE_DISPLAY.get(mod_id, f"Module {mod_id}"),
            "done": done,
            "total": total,
            "xp": mod_xp,
            "max_xp": max_xp,
            "current": mod_id == current_mod,
            "bar": f"[bright_green]{'█' * filled}[/bright_green][grey30]{'░' * (10 - filled)}[/grey30]",
        })
    return rows


def _show_compact_progress(levels: list[dict], progress: dict) -> None:
    rows = _module_rows(levels, progress)
    current_mod = int(progress.get("current_module", 1) or 1)
    current_level = progress.get("current_level", 1)
    completed = len(progress.get("completed_levels", []))
    total_levels = len(levels)

    summary = Table(box=box.SIMPLE, show_header=False, expand=False)
    summary.add_column("key", style="grey70", width=16)
    summary.add_column("value", style="bold white")
    summary.add_row("Current", f"Module {current_mod}  •  Level {current_level}")
    summary.add_row("Completed", f"{completed} / {total_levels}")
    summary.add_row("View", "Type `status full` for all 26 modules")
    console.print(Panel(summary, border_style="bright_magenta", box=box.ROUNDED, padding=(0, 2)))

    nearby = [row for row in rows if abs(row["id"] - current_mod) <= 1]
    table = Table(box=box.SIMPLE_HEAVY, expand=True, show_header=True, header_style="bold bright_cyan")
    table.add_column("#", width=4, style="grey50")
    table.add_column("Module", ratio=3, style="bright_cyan")
    table.add_column("Progress", width=12)
    table.add_column("Done", width=8, justify="right")
    table.add_column("XP", width=12, justify="right", style="bright_magenta")

    for row in nearby:
        name = row["name"]
        if row["current"]:
            name = f"[bold bright_yellow]{name}[/bold bright_yellow]"
        done_style = "bright_green" if row["done"] == row["total"] else ("bright_yellow" if row["done"] > 0 else "grey50")
        table.add_row(
            str(row["id"]),
            name,
            row["bar"],
            f"[{done_style}]{row['done']}/{row['total']}[/{done_style}]",
            f"{row['xp']:,}/{row['max_xp']:,}",
        )

    console.print(table)


# ─────────────────────────────────────────────────────────────────────────────
# Title screen  (first-run, before name is known)
# ─────────────────────────────────────────────────────────────────────────────

def show_title_screen() -> None:
    logo     = _logo_text()
    subtitle = Text("  500 challenges  •  26 modules  •  Real bash scripting", style="grey70")
    author   = Text("  Design and implementation by: Jalil Abdollahi", style="bold white")
    contact  = Text("  jalil.abdollahi@gmail.com", style="bright_magenta")
    body = Group(logo, Text(""), author, contact, Text(""), subtitle)
    console.print(Panel(body, border_style="bright_cyan", box=box.ROUNDED, padding=(1, 2)))


# ─────────────────────────────────────────────────────────────────────────────
# Mission briefing
# ─────────────────────────────────────────────────────────────────────────────

def show_mission(
    level_data: dict,
    level_index: int,
    total_levels: int,
    workspace: Path,
    show_workspace: bool = True,
    script_exists: bool = False,
) -> None:
    diff   = level_data.get("difficulty", "beginner")
    color  = DIFFICULTY_COLOR.get(diff, "white")
    stars  = DIFFICULTY_STARS.get(diff, "★☆☆☆☆")
    mod_id = level_data.get("module", 1)

    meta = Text.assemble(
        (f"Module {mod_id}/26  •  Level {level_index}/{total_levels}", "bright_cyan"),
        ("    ", ""),
        (stars, "bright_yellow"),
        ("  ", ""),
        (diff.upper(), color),
        ("    ", ""),
        (f"+{level_data.get('xp', 0)} XP", "bold bright_magenta"),
    )

    objective = level_data.get("objective", "").strip()
    concepts  = "  •  ".join(level_data.get("concepts", []))

    content = Group(
        meta,
        Rule(style="grey50"),
        Text(f"MISSION:    {level_data.get('title', '')}", style="bold white"),
        Text(""),
        Text(f"OBJECTIVE:  {objective}", style="bright_green"),
        Text(""),
        Text(f"CONCEPTS:   {concepts}", style="grey70"),
    )

    console.print(
        Panel(
            content,
            title="[bold bright_cyan]◈ MISSION BRIEFING[/bold bright_cyan]",
            border_style="bright_cyan",
            box=box.ROUNDED,
            padding=(1, 2),
        )
    )

    if script_exists:
        next_step = "Next step: press [bold]1[/bold] to check your code, or [bold]4[/bold] to review it."
    else:
        next_step = "Next step: press [bold]3[/bold] to open `solution.sh` and start writing."
    console.print(
        Panel(
            next_step + "  Need help? Press [bold]5[/bold] for a hint. New to Bash? Type [bold]guide bash[/bold].",
            title="[bold bright_yellow]RECOMMENDED[/bold bright_yellow]",
            border_style="bright_yellow",
            box=box.ROUNDED,
            padding=(0, 1),
        )
    )

    if show_workspace:
        console.print(
            Panel(
                _sandbox_tree(workspace),
                title="[bold blue]WORKSPACE[/bold blue]",
                border_style="blue",
                box=box.SIMPLE,
                padding=(0, 1),
            )
    )

    console.print(
        "[dim]  1·check  2·watch  3·edit code  4·view code  5·hint  6·mission  guide bash·learn bash  ls·files  7·reset  9·status  0·quit[/dim]\n"
    )


def _sandbox_tree(workspace: Path) -> Tree:
    tree = Tree(f"[dim]{workspace}[/dim]")
    if not workspace.exists():
        tree.add("[dim]workspace not ready — type reset[/dim]")
        return tree
    entries = sorted(workspace.iterdir(), key=lambda p: (not p.is_dir(), p.name.lower()))
    if not entries:
        tree.add("[dim](empty)[/dim]")
        return tree
    for entry in entries[:20]:
        label = f"[bold]{entry.name}[/bold]" if entry.name == "solution.sh" else entry.name
        label += "/" if entry.is_dir() else ""
        tree.add(label)
    if len(entries) > 20:
        tree.add(f"[dim]… and {len(entries) - 20} more[/dim]")
    return tree


# ─────────────────────────────────────────────────────────────────────────────
# Run results
# ─────────────────────────────────────────────────────────────────────────────

def show_run_result(report: dict) -> None:
    passed_all = report.get("passed", False)
    results    = report.get("results", [])

    table = Table(box=box.SIMPLE_HEAVY, expand=True, show_header=True)
    table.add_column("#",        width=4,  style="grey50")
    table.add_column("Status",   width=10)
    table.add_column("Args",     ratio=2,  style="grey70")
    table.add_column("Expected", ratio=3,  style="white")
    table.add_column("Got",      ratio=3,  style="white")

    for idx, r in enumerate(results, 1):
        ok       = r.get("passed", False)
        status   = "[bold bright_green]✓ PASS[/bold bright_green]" if ok else "[bold bright_red]✗ FAIL[/bold bright_red]"
        args_str = " ".join(str(a) for a in r.get("args", [])) or "[dim](none)[/dim]"

        if ok:
            expected = "[dim]—[/dim]"
            got      = "[dim]—[/dim]"
        else:
            expected = repr(r.get("expected_stdout", ""))
            got      = r.get("message", "") or repr(r.get("actual_stdout", ""))

        table.add_row(str(idx), status, args_str, expected, got)

    color   = "bright_green" if passed_all else "bright_red"
    icon    = "✓" if passed_all else "✗"
    summary = report.get("summary", "")

    console.print(
        Panel(
            table,
            title=f"[bold {color}]{icon}  {summary}[/bold {color}]",
            border_style=color,
            box=box.ROUNDED,
            padding=(0, 1),
        )
    )
    if not passed_all:
        console.print(
            Panel(
                "Next step: press [bold]3[/bold] to edit your code, [bold]4[/bold] to review it, or [bold]5[/bold] for a hint.",
                border_style="bright_yellow",
                box=box.ROUNDED,
                padding=(0, 1),
            )
        )


# ─────────────────────────────────────────────────────────────────────────────
# Level complete / victory
# ─────────────────────────────────────────────────────────────────────────────

def show_level_complete(level_data: dict, xp_earned: int, elapsed_seconds: float | None = None) -> None:
    time_str = ""
    if elapsed_seconds is not None:
        mins, secs = divmod(int(elapsed_seconds), 60)
        time_str = f"  ·  ⏱ {mins}m {secs:02d}s" if mins else f"  ·  ⏱ {secs}s"

    body = Group(
        Text(f"  MISSION ACCOMPLISHED{time_str}", style="bold bright_green"),
        Text(f"  {MODULE_DISPLAY.get(level_data.get('module', 1), '')}  •  {level_data.get('title', '')}", style="white"),
        Text(f"  XP Earned: +{xp_earned}", style="bold bright_magenta"),
    )
    console.print(Panel(body, border_style="bright_green", box=box.DOUBLE, padding=(1, 2)))

def show_post_level_debrief(level_path: Path, elapsed_seconds: float | None = None) -> None:
    debrief = level_path / "debrief.md"
    mistakes = level_path / "common-mistakes.md"

    has_debrief = debrief.exists()
    has_mistakes = mistakes.exists()
    if not has_debrief and not has_mistakes:
        return

    time_suffix = ""
    if elapsed_seconds is not None:
        mins, secs = divmod(int(elapsed_seconds), 60)
        actual = f"{mins}m {secs:02d}s" if mins else f"{secs}s"
        time_suffix = f"  ·  ⏱ {actual}"

    console.print()
    console.print(
        Panel(
            Text.assemble(
                ("  Level complete — reading lesson", "bold bright_green"),
                (time_suffix, "bright_yellow"),
                ("   (q to skip)", "grey70"),
            ),
            border_style="bright_green",
            box=box.HEAVY_EDGE,
            padding=(0, 1),
        )
    )

    if has_debrief:
        _pager.show(
            debrief.read_text(encoding="utf-8"),
            title="Mission Debrief",
            border="bright_green",
            clear_first=False,
        )

    if has_mistakes:
        _pager.show(
            mistakes.read_text(encoding="utf-8"),
            title="Common Mistakes",
            border="bright_yellow",
        )


def show_module_complete(_module_name: str, certificate_text: str) -> None:
    console.print(
        Panel(
            Text(certificate_text, style="bold bright_cyan"),
            title="[bold bright_yellow]★  MODULE COMPLETE  ★[/bold bright_yellow]",
            border_style="bright_yellow",
            box=box.DOUBLE,
            padding=(1, 4),
        )
    )


# ─────────────────────────────────────────────────────────────────────────────
# Status
# ─────────────────────────────────────────────────────────────────────────────

def show_status(progress: dict, levels: list[dict], full: bool = False) -> None:
    completed = set(progress.get("completed_levels", []))
    skipped   = set(progress.get("skipped_levels", []))
    total     = len(levels)
    total_xp  = progress.get("total_xp", 0)
    max_xp    = sum(l.get("xp", 0) for l in levels)

    console.print(Rule("[bright_cyan]Mission Progress[/bright_cyan]"))

    summary = Table(box=box.SIMPLE, show_header=False, expand=False)
    summary.add_column("key",   style="grey70",   width=16)
    summary.add_column("value", style="bold white")
    summary.add_row("Hacker",    progress.get("player_name") or "Unknown")
    summary.add_row("Total XP",  f"{total_xp:,} / {max_xp:,}")
    summary.add_row("Completed", f"{len(completed)} / {total}")
    summary.add_row("Skipped",   str(len(skipped)))
    summary.add_row(
        "Current",
        f"Module {progress.get('current_module', 1)}  •  Level {progress.get('current_level', 1)}",
    )
    console.print(Panel(summary, border_style="bright_magenta", box=box.ROUNDED, padding=(0, 2)))
    if full:
        _show_module_progress(levels, progress)
    else:
        _show_compact_progress(levels, progress)


# ─────────────────────────────────────────────────────────────────────────────
# Hint
# ─────────────────────────────────────────────────────────────────────────────

def show_hint(hint_text: str, hint_number: int) -> None:
    colors = {1: "bright_yellow", 2: "yellow", 3: "bright_red"}
    color  = colors.get(hint_number, "yellow")
    icons  = {1: "💡", 2: "🔍", 3: "🔑"}
    icon   = icons.get(hint_number, "💡")
    console.print(
        Panel(
            Text(hint_text.strip(), style="white"),
            title=f"[bold {color}]{icon}  Hint {hint_number}/3[/bold {color}]",
            border_style=color,
            box=box.ROUNDED,
            padding=(1, 2),
        )
    )


def show_hint_exhausted() -> None:
    console.print(
        Panel(
            "You have used all 3 hints for this level. Try [bold]guide[/bold] for a step-by-step walkthrough or [bold]answer[/bold] to inspect the reference solution.",
            title="[bold bright_yellow]NO MORE HINTS[/bold bright_yellow]",
            border_style="bright_yellow",
            box=box.ROUNDED,
            padding=(1, 2),
        )
    )


def show_guide(path: Path) -> None:
    if not path.exists():
        console.print("[yellow]No walkthrough is available for this level yet.[/yellow]")
        return
    _pager.show(
        path.read_text(encoding="utf-8"),
        title="Level Guide",
        border="bright_cyan",
        clear_first=False,
    )


def show_answer(path: Path) -> None:
    if not path.exists():
        console.print("[yellow]No reference solution is available for this level yet.[/yellow]")
        return
    console.print(
        Panel(
            Syntax(
                path.read_text(encoding="utf-8"),
                "bash",
                line_numbers=True,
                theme="monokai",
                word_wrap=False,
            ),
            title="[bold bright_red]REFERENCE SOLUTION[/bold bright_red]",
            border_style="bright_red",
            box=box.ROUNDED,
            padding=(0, 1),
        )
    )


# ─────────────────────────────────────────────────────────────────────────────
# Script viewer
# ─────────────────────────────────────────────────────────────────────────────

def show_script(path: Path) -> None:
    if not path.exists():
        console.print(
            Panel(
                Text("You do not have any code yet. Press [bold]3[/bold] to open the editor and create `solution.sh`.", style="grey70"),
                title="[bold bright_yellow]YOUR CODE[/bold bright_yellow]",
                border_style="bright_yellow",
                box=box.ROUNDED,
            )
        )
        return
    console.print(
        Panel(
            Syntax(
                path.read_text(encoding="utf-8"),
                "bash",
                line_numbers=True,
                theme="monokai",
                word_wrap=False,
            ),
            title="[bold blue]YOUR CURRENT CODE[/bold blue]",
            border_style="blue",
            box=box.ROUNDED,
            padding=(0, 1),
        )
    )


# ─────────────────────────────────────────────────────────────────────────────
# Help
# ─────────────────────────────────────────────────────────────────────────────

def show_help() -> None:
    def _section(title: str, rows: list[tuple[str, str]], color: str) -> Text:
        t = Text()
        t.append(f"  {title}\n", style=f"bold {color}")
        t.append(f"  {'─' * 50}\n", style="grey50")
        for cmd, desc in rows:
            t.append(f"  {cmd:<18}", style=f"bold {color}")
            t.append(f"{desc}\n", style="white")
        return t

    validate = _section("VALIDATE", [
        ("1  check",     "Run the tests and see what still needs fixing"),
        ("2  watch",     "Auto-run every 3s until all tests pass"),
        ("4  view code", "Show your current solution.sh"),
    ], "bright_cyan")

    write = _section("WRITE", [
        ("3  edit code", "Open solution.sh in $EDITOR (default: nano)"),
        ("ls",           "Show the workspace files for this level"),
        ("7  reset",     "Wipe workspace and start the level fresh"),
    ], "bright_yellow")

    learn = _section("LEARN", [
        ("5  hint",      "Reveal the next hint  (up to 3 per level)"),
        ("guide",        "Show a step-by-step walkthrough for this level"),
        ("guide bash",   "Open the beginner Bash handbook"),
        ("answer",       "Reveal the reference solution for this level"),
        ("6  mission",   "Re-read the mission briefing"),
    ], "bright_green")

    navigate = _section("NAVIGATE", [
        ("9  status",    "Compact progress view"),
        ("status full",  "Show the full 26-module campaign map"),
        ("8  skip",      "Skip this level — no XP awarded"),
        ("0  quit",      "Save progress and exit"),
        ("?  help",      "Show this command reference"),
    ], "grey70")

    body = Text()
    for section in (validate, write, learn, navigate):
        body.append_text(section)
        body.append("\n")

    console.print(
        Panel(
            body,
            title="[bold white]COMMAND REFERENCE[/bold white]",
            border_style="grey50",
            box=box.ROUNDED,
            padding=(0, 1),
        )
    )


# ─────────────────────────────────────────────────────────────────────────────
# Paginated debrief viewer
# ─────────────────────────────────────────────────────────────────────────────

class PaginatedDisplay:
    def __init__(self, lines_per_page: int | None = None) -> None:
        self.lines_per_page = lines_per_page or self._detect_height()

    @staticmethod
    def _detect_height() -> int:
        try:
            return max(10, console.size.height - 8)
        except Exception:
            return 22

    @staticmethod
    def _getkey() -> str:
        if _WINDOWS:
            import msvcrt as _m  # type: ignore[import]
            while True:
                ch = _m.getwch()
                if ch in ("\x00", "\xe0"):
                    _m.getwch()
                    continue
                return "\n" if ch == "\r" else ch
        with open("/dev/tty", "rb") as tty_dev:
            fd  = tty_dev.fileno()
            old = termios.tcgetattr(fd)
            try:
                tty.setraw(fd)
                ch = tty_dev.read(1).decode("utf-8", errors="replace")
                if ch == "\x1b" and select.select([tty_dev], [], [], 0.05)[0]:
                    tty_dev.read(2)
                    return ""
                return "\n" if ch == "\r" else ch
            finally:
                termios.tcsetattr(fd, termios.TCSADRAIN, old)

    @staticmethod
    def _code_states(lines: list[str]) -> list[bool]:
        states: list[bool] = []
        inside = False
        for line in lines:
            states.append(inside)
            if line.strip().startswith("```"):
                inside = not inside
        return states

    def _page_ranges(self, lines: list[str]) -> list[tuple[int, int]]:
        code_states = self._code_states(lines)
        ranges: list[tuple[int, int]] = []
        start = 0
        total = len(lines)
        while start < total:
            end = min(start + self.lines_per_page, total)
            while end < total and code_states[end - 1]:
                end += 1
            if end == start:
                end = min(start + self.lines_per_page, total)
            ranges.append((start, end))
            start = end
        return ranges or [(0, 0)]

    def _nav_hint(self, page: int, total: int) -> None:
        parts = ["[dim]Navigate:[/dim]", "[bright_cyan]Space/Enter[/bright_cyan] next"]
        if page > 1:
            parts.append("[bright_cyan]b[/bright_cyan] back")
        if total > 1:
            parts.append("[bright_cyan]g[/bright_cyan] start")
        parts.append("[bright_cyan]q[/bright_cyan] close")
        console.print("  " + "  •  ".join(parts))

    def show(self, text: str, title: str = "Content", border: str = "bright_green", clear_first: bool = True) -> None:
        lines  = text.split("\n")
        ranges = self._page_ranges(lines)
        total  = len(ranges)
        idx    = 0

        while True:
            s, e     = ranges[idx]
            content  = "\n".join(lines[s:e])
            page_tag = f"  [Page {idx + 1}/{total}]" if total > 1 else ""

            if idx == 0 and not clear_first:
                console.print()
                console.print(
                    Panel(
                        Markdown(content),
                        title=f"[bold {border}]{title}{page_tag}[/bold {border}]",
                        border_style=border,
                        box=box.DOUBLE,
                        padding=(1, 2),
                    )
                )
            else:
                console.clear()
                console.print(
                    Panel(
                        Markdown(content),
                        title=f"[bold {border}]{title}{page_tag}[/bold {border}]",
                        border_style=border,
                        box=box.DOUBLE,
                        padding=(1, 2),
                    )
                )

            console.print()
            self._nav_hint(idx + 1, total)
            key = self._getkey()
            if not key:
                continue
            k = key.lower()
            if k in ("\n", " ", ""):
                if idx == total - 1:
                    break
                idx = min(total - 1, idx + 1)
            elif k == "b" and idx > 0:
                idx -= 1
            elif k == "g":
                idx = 0
            elif k == "q":
                break
        console.print()


_pager = PaginatedDisplay()
