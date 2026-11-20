#!/usr/bin/python3
"""Sync shared Codex preferences while keeping the whole [projects] tree local."""

import os
from pathlib import Path
import tempfile
import tomllib


def normalize(text):
    return text.strip() + "\n" if text.strip() else ""


def split_projects(text):
    """Preserve TOML text and comments; validate the extracted table contents."""
    parsed = tomllib.loads(text)
    shared, projects = [], []
    in_projects = False
    lines = text.splitlines(keepends=True)
    for index, line in enumerate(lines):
        if line.lstrip().startswith("["):
            try:
                header = tomllib.loads(line)
                # A header-looking line inside a multiline string or array is
                # data, not a table. Only complete TOML prefixes can end here.
                tomllib.loads("".join(lines[:index]))
            except tomllib.TOMLDecodeError:
                pass
            else:
                in_projects = "projects" in header
        (projects if in_projects else shared).append(line)
    shared, projects = normalize("".join(shared)), normalize("".join(projects))
    expected = dict(parsed)
    local_projects = expected.pop("projects", None)
    if tomllib.loads(shared) != expected or tomllib.loads(projects) != (
        {"projects": local_projects} if local_projects is not None else {}
    ):
        raise ValueError("Project settings must use [projects] or [projects.\"path\"] tables")
    return shared, projects


def write_changed(path, text):
    if path.exists() and path.read_text() == text:
        return
    path.parent.mkdir(parents=True, exist_ok=True)
    mode = path.stat().st_mode & 0o777 if path.exists() else 0o600
    descriptor, temporary = tempfile.mkstemp(dir=path.parent)
    try:
        with os.fdopen(descriptor, "w") as output:
            output.write(text)
        os.chmod(temporary, mode)
        os.replace(temporary, path)
    finally:
        Path(temporary).unlink(missing_ok=True)


def sync(shared_path, local_path, baseline_path):
    local, projects = split_projects(local_path.read_text() if local_path.exists() else "")
    shared = normalize(shared_path.read_text()) if shared_path.exists() else ""
    if "projects" in tomllib.loads(shared):
        raise ValueError("Shared config must not contain project trust settings")
    baseline = normalize(baseline_path.read_text()) if baseline_path.exists() else None
    if not local_path.exists():
        chosen = shared
    elif not shared_path.exists():
        chosen = local
    elif local == shared or local == baseline:
        chosen = shared
    elif shared == baseline:
        chosen = local
    else:
        # On first sync or when both shared preferences changed, follow the
        # existing newest-file-wins convention. Trust-only changes compare equal
        # to the baseline, so they cannot republish stale preferences.
        chosen = local if local_path.stat().st_mtime > shared_path.stat().st_mtime else shared
    merged = chosen.rstrip() + ("\n\n" if chosen and projects else "") + projects
    merged = normalize(merged)
    if tomllib.loads(merged).get("projects") != tomllib.loads(projects).get("projects"):
        raise ValueError("Sync would change this machine's project trust settings")
    write_changed(shared_path, chosen)
    write_changed(local_path, merged)
    write_changed(baseline_path, chosen)


if __name__ == "__main__":
    home = Path.home()
    state = Path(os.environ.get("XDG_STATE_HOME", home / ".local/state"))
    sync(
        Path(__file__).with_name("config.toml"),
        home / ".codex/config.toml",
        state / "dotdotdot/codex-shared.toml",
    )
