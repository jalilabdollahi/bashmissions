#!/usr/bin/env python3
"""BashMissions main game loop — modelled after k8smissions."""
from __future__ import annotations

import json
import os
import readline  # noqa: F401 — enables arrow keys and history in Prompt.ask()
import subprocess
import sys
import time
from pathlib import Path

from rich.prompt import Prompt

REPO_ROOT = Path(__file__).resolve().parent.parent
if str(REPO_ROOT) not in sys.path:
    sys.path.insert(0, str(REPO_ROOT))

try:
    from engine.certificate import render_certificate, save_certificate
    from engine.player import PlayerProgress
    from engine.runner import prepare_level, run_level, level_workspace, set_active_workspace
    from engine.scaffold import create_starter_script
    from engine.ui import (
        console,
        show_answer,
        show_guide,
        show_help,
        show_hint,
        show_hint_exhausted,
        show_level_complete,
        show_mission,
        show_module_complete,
        show_post_level_debrief,
        show_run_result,
        show_script,
        show_status,
        show_title_screen,
        show_welcome,
    )
    from engine.validator import validate_all
except ModuleNotFoundError:
    from certificate import render_certificate, save_certificate
    from player import PlayerProgress
    from runner import prepare_level, run_level, level_workspace, set_active_workspace
    from scaffold import create_starter_script
    from ui import (
        console,
        show_answer,
        show_guide,
        show_help,
        show_hint,
        show_hint_exhausted,
        show_level_complete,
        show_mission,
        show_module_complete,
        show_post_level_debrief,
        show_run_result,
        show_script,
        show_status,
        show_title_screen,
        show_welcome,
    )
    from validator import validate_all

LEVELS_PATH   = REPO_ROOT / "levels.json"
PROGRESS_PATH = REPO_ROOT / "progress.json"

COMMAND_ALIASES: dict[str, str] = {
    "1": "run",
    "2": "watch",
    "3": "edit",
    "4": "show",
    "handbook": "guide bash",
    "bashguide": "guide bash",
    "bash-guide": "guide bash",
    "check": "run",
    "view": "show",
    "code": "show",
    "guide": "guide",
    "answer": "answer",
    "ls": "workspace",
    "5": "hint",
    "6": "objective",
    "mission": "objective",
    "7": "reset",
    "8": "skip",
    "9": "status",
    "0": "quit",
    "q": "quit",
    "?": "help",
    "h": "help",
}


# ─────────────────────────────────────────────────────────────────────────────
# Data loading
# ─────────────────────────────────────────────────────────────────────────────

def load_levels() -> list[dict]:
    with LEVELS_PATH.open("r", encoding="utf-8") as f:
        return json.load(f)


def level_map(levels: list[dict]) -> dict[int, dict]:
    return {int(lv["id"]): lv for lv in levels}


def read_text(path: Path) -> str:
    return path.read_text(encoding="utf-8").strip() if path.exists() else ""


def level_dir(level_data: dict) -> Path:
    return REPO_ROOT / level_data["path"]


def load_hint(level_data: dict, hint_number: int) -> str:
    return read_text(level_dir(level_data) / f"hint-{hint_number}.txt")


# ─────────────────────────────────────────────────────────────────────────────
# Player name prompt  (shown only on first run)
# ─────────────────────────────────────────────────────────────────────────────

def ensure_player_name(progress: PlayerProgress) -> None:
    if progress.data.get("player_name"):
        return
    show_title_screen()
    console.print()
    name = Prompt.ask(
        "[bold bright_cyan]Enter your hacker name[/bold bright_cyan]",
        default="Hacker",
    ).strip() or "Hacker"
    progress.set_player_name(name)


# ─────────────────────────────────────────────────────────────────────────────
# Navigation helpers
# ─────────────────────────────────────────────────────────────────────────────

def current_level(levels: list[dict], progress: PlayerProgress) -> dict | None:
    current_id   = progress.data.get("current_level", 1)
    levels_by_id = level_map(levels)
    return levels_by_id.get(int(current_id))


def advance_level(levels: list[dict], progress: PlayerProgress, level_data: dict) -> bool:
    next_id      = level_data["id"] + 1
    levels_by_id = level_map(levels)
    if next_id not in levels_by_id:
        return False
    nxt = levels_by_id[next_id]
    progress.set_current(nxt["module"], nxt["id"])
    progress.save()
    return True


def maybe_award_module(levels: list[dict], progress: PlayerProgress, module_id: int) -> None:
    mod_levels = [lv for lv in levels if lv["module"] == module_id]
    completed  = set(progress.data.get("completed_levels", []))
    if not all(lv["id"] in completed for lv in mod_levels):
        return
    if not progress.award_module_certificate(module_id):
        return
    module_name = mod_levels[0].get("module_display", f"Module {module_id}")
    player_name = progress.data.get("player_name") or "Hacker"
    cert        = render_certificate(module_name, player_name)
    save_certificate(mod_levels[0]["module_name"], cert)
    progress.save()
    show_module_complete(module_name, cert)


# ─────────────────────────────────────────────────────────────────────────────
# Editor helper
# ─────────────────────────────────────────────────────────────────────────────

def open_editor(path: Path) -> None:
    editor = os.environ.get("EDITOR") or os.environ.get("VISUAL") or "nano"
    subprocess.run([editor, str(path)], check=False)


def current_script_path(level_data: dict, workspace: Path) -> Path:
    return workspace / level_data.get("expected_script_name", "solution.sh")


def level_guide_path(level_data: dict) -> Path:
    return level_dir(level_data) / "solution-guide.md"


def level_answer_path(level_data: dict) -> Path:
    return level_dir(level_data) / "answer.sh"


def bash_guide_path() -> Path:
    return REPO_ROOT / "BASH_GUIDE.md"


# ─────────────────────────────────────────────────────────────────────────────
# Watch mode
# ─────────────────────────────────────────────────────────────────────────────

def watch_mode(level_data: dict, workspace: Path) -> bool:
    """Auto-run every 3s until all tests pass. Returns True if passed."""
    from rich.text import Text
    from rich.panel import Panel
    from rich import box as rbox

    interval = 3
    console.print(Panel(
        Text.assemble(
            ("Watch mode — ", "bright_cyan"),
            ("validator runs every 3s", "white"),
            ("  •  ", "grey50"),
            ("Ctrl+C to cancel", "grey70"),
        ),
        border_style="bright_cyan",
        box=rbox.ROUNDED,
        padding=(0, 2),
    ))
    attempt = 0
    try:
        while True:
            attempt += 1
            results = run_level(level_data, workspace)
            report  = validate_all(results)
            show_run_result(report)
            if report["passed"]:
                return True
            for remaining in range(interval, 0, -1):
                console.print(
                    f"\r[grey70]  ↺ Attempt {attempt} failed — rechecking in {remaining}s...[/grey70]",
                    end="",
                )
                time.sleep(1)
            console.print()
    except KeyboardInterrupt:
        console.print("\n[yellow]Watch mode cancelled.[/yellow]")
        return False


# ─────────────────────────────────────────────────────────────────────────────
# Main game loop
# ─────────────────────────────────────────────────────────────────────────────

def game_loop() -> int:
    levels   = load_levels()
    progress = PlayerProgress(PROGRESS_PATH)

    # ── First-run: ask name, then show full welcome ──
    ensure_player_name(progress)

    # ── Every-run: show ASCII logo + progress table ──
    show_welcome(
        player_name=progress.data.get("player_name") or "Hacker",
        total_xp=progress.data.get("total_xp", 0),
        levels=levels,
        progress=progress.data,
    )

    while True:
        # Reload levels and progress at top of each level loop
        levels   = load_levels()
        lv_data  = current_level(levels, progress)
        if not lv_data:
            console.print("[bold bright_green]All 500 levels complete. You are a bash master.[/bold bright_green]")
            return 0

        workspace = level_workspace(lv_data)
        if not workspace.exists():
            workspace = prepare_level(lv_data)
        else:
            set_active_workspace(workspace)

        show_mission(
            lv_data,
            lv_data["id"],
            len(levels),
            workspace,
            show_workspace=False,
            script_exists=current_script_path(lv_data, workspace).exists(),
        )
        started = time.time()

        while True:
            try:
                command = Prompt.ask(
                    "[bold bright_cyan]bashmissions[/bold bright_cyan]"
                ).strip()
            except (EOFError, KeyboardInterrupt):
                progress.save()
                return 0

            if not command:
                continue

            command = COMMAND_ALIASES.get(command, command)
            command_name, _, command_arg = command.partition(" ")
            command_arg = command_arg.strip()

            # ── run ──────────────────────────────────────────────────────────
            if command_name == "run":
                results = run_level(lv_data, workspace)
                report  = validate_all(results)
                show_run_result(report)
                if not report["passed"]:
                    continue
                elapsed = time.time() - started
                progress.add_xp(lv_data.get("xp", 0))
                progress.complete_level(lv_data["id"], elapsed)
                maybe_award_module(levels, progress, lv_data["module"])
                show_level_complete(lv_data, lv_data.get("xp", 0), elapsed)
                show_post_level_debrief(level_dir(lv_data), elapsed)
                if not advance_level(levels, progress, lv_data):
                    progress.save()
                    console.print("[bold bright_green]Campaign complete.[/bold bright_green]")
                    return 0
                progress.save()
                break  # go to next level

            # ── watch ────────────────────────────────────────────────────────
            if command_name == "watch":
                passed = watch_mode(lv_data, workspace)
                if passed:
                    elapsed = time.time() - started
                    progress.add_xp(lv_data.get("xp", 0))
                    progress.complete_level(lv_data["id"], elapsed)
                    maybe_award_module(levels, progress, lv_data["module"])
                    show_level_complete(lv_data, lv_data.get("xp", 0), elapsed)
                    show_post_level_debrief(level_dir(lv_data), elapsed)
                    if not advance_level(levels, progress, lv_data):
                        progress.save()
                        return 0
                    progress.save()
                    break
                continue

            # ── edit ─────────────────────────────────────────────────────────
            if command_name == "edit":
                script_path = current_script_path(lv_data, workspace)
                if not script_path.exists():
                    create_starter_script(lv_data, level_dir(lv_data), script_path)
                    if not script_path.exists():
                        script_path.write_text("#!/usr/bin/env bash\n\n", encoding="utf-8")
                open_editor(script_path)
                continue

            # ── show ─────────────────────────────────────────────────────────
            if command_name == "show":
                show_script(current_script_path(lv_data, workspace))
                continue

            # ── workspace ────────────────────────────────────────────────────
            if command_name == "workspace":
                show_mission(
                    lv_data,
                    lv_data["id"],
                    len(levels),
                    workspace,
                    show_workspace=True,
                    script_exists=current_script_path(lv_data, workspace).exists(),
                )
                continue

            # ── hint ─────────────────────────────────────────────────────────
            if command_name == "hint":
                hint_number = progress.next_hint_number(lv_data["id"])
                hint_text   = load_hint(lv_data, hint_number)
                if not hint_text:
                    show_hint_exhausted()
                    continue
                show_hint(hint_text, hint_number)
                continue

            # ── guide ────────────────────────────────────────────────────────
            if command_name == "guide":
                if command_arg in {"bash", "general", "basics"}:
                    show_guide(bash_guide_path())
                else:
                    show_guide(level_guide_path(lv_data))
                continue

            # ── answer ───────────────────────────────────────────────────────
            if command_name == "answer":
                confirm = Prompt.ask(
                    "[bold bright_red]Reveal the reference solution?[/bold bright_red]",
                    choices=["y", "n"],
                    default="n",
                )
                if confirm == "y":
                    show_answer(level_answer_path(lv_data))
                else:
                    console.print("[grey70]Keeping the solution hidden for now.[/grey70]")
                continue

            # ── objective ────────────────────────────────────────────────────
            if command_name == "objective":
                show_mission(
                    lv_data,
                    lv_data["id"],
                    len(levels),
                    workspace,
                    script_exists=current_script_path(lv_data, workspace).exists(),
                )
                continue

            # ── reset ────────────────────────────────────────────────────────
            if command_name == "reset":
                workspace = prepare_level(lv_data)
                started   = time.time()
                console.print("[bright_green]Workspace reset.[/bright_green]")
                show_mission(
                    lv_data,
                    lv_data["id"],
                    len(levels),
                    workspace,
                    script_exists=current_script_path(lv_data, workspace).exists(),
                )
                continue

            # ── skip ─────────────────────────────────────────────────────────
            if command_name == "skip":
                progress.skip_level(lv_data["id"])
                if not advance_level(levels, progress, lv_data):
                    progress.save()
                    return 0
                progress.save()
                break

            # ── status ───────────────────────────────────────────────────────
            if command_name == "status":
                levels = load_levels()
                show_status(progress.data, levels, full=command_arg == "full")
                continue

            # ── help ─────────────────────────────────────────────────────────
            if command_name in {"help", "?"}:
                show_help()
                continue

            # ── quit ─────────────────────────────────────────────────────────
            if command_name in {"quit", "exit"}:
                progress.save()
                console.print("[grey70]Progress saved. See you next time.[/grey70]")
                return 0

            console.print(f"[yellow]Unknown command: [bold]{command}[/bold] — type [bold]help[/bold] for options.[/yellow]")


if __name__ == "__main__":
    try:
        raise SystemExit(game_loop())
    except KeyboardInterrupt:
        sys.exit(130)
