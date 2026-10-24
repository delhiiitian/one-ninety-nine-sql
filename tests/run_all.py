#!/usr/bin/env python3
"""Run every SQL and Python example in the repo and report failures.

Usage (from the repo root):  python3 tests/run_all.py [path-filter]

A .sql file passes when sqlite3 runs it with no errors. A file that shows
errors on purpose declares how many with a line like:  -- EXPECT-ERRORS: 2
Python files (*.py) pass when they exit with status 0.
Inside projects/, only each project's run.sql (which .reads the other files)
and its Python files are run.
"""
import pathlib
import re
import subprocess
import sys

ROOT = pathlib.Path(__file__).resolve().parent.parent
SKIP_DIRS = {"tests", ".git", ".github"}


def expected_errors(text):
    match = re.search(r"--\s*EXPECT-ERRORS:\s*(\d+)", text)
    return int(match.group(1)) if match else 0


def run_sql(path):
    text = path.read_text()
    result = subprocess.run(
        ["sqlite3", "-box"], input=text, capture_output=True, text=True, cwd=ROOT
    )
    errors = [l for l in result.stderr.splitlines() if "error" in l.lower()]
    want = expected_errors(text)
    ok = len(errors) == want
    return ok, f"expected {want} error(s), got {len(errors)}: {errors}"


def run_py(path):
    result = subprocess.run(
        [sys.executable, path.name], capture_output=True, text=True, cwd=path.parent
    )
    return result.returncode == 0, result.stderr[-500:]


def main():
    flt = sys.argv[1] if len(sys.argv) > 1 else ""
    files = sorted(
        p for p in ROOT.rglob("*")
        if p.suffix in {".sql", ".py"}
        and not SKIP_DIRS & set(p.relative_to(ROOT).parts)
        and flt in str(p.relative_to(ROOT))
        and not p.name.startswith("_")
        and (p.parts[len(ROOT.parts)] != "projects" or p.name == "run.sql" or p.suffix == ".py")
    )
    failed = 0
    for path in files:
        ok, detail = run_sql(path) if path.suffix == ".sql" else run_py(path)
        print(("PASS " if ok else "FAIL ") + str(path.relative_to(ROOT)))
        if not ok:
            failed += 1
            print("     " + detail)
    print(f"\n{len(files) - failed}/{len(files)} passed")
    sys.exit(1 if failed else 0)


if __name__ == "__main__":
    main()
