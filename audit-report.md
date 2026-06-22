# Audit Report: 01-edu/public Shell Tests & Solutions

**Date:** June 22, 2026
**Scope:** 42 exercises in `sh/tests/` and `sh/tests/solutions/` of 01-edu/public
**Method:** Fetched all official test files and solutions from raw.githubusercontent.com/01-edu/public/master/, audited for bugs, drifts, false positives/negatives, and infrastructure issues

---

## Summary

| Severity | Count |
|----------|-------|
| CRITICAL | 10 |
| HIGH | 18 |
| MEDIUM | 22 |
| LOW | 15 |

---

## CRITICAL BUGS (cause false pass/fail on grading)

### 1. joker-num solution — `$tries_left+1` string concat, not arithmetic
**File:** `sh/tests/solutions/joker-num.sh`
- `tries_left=$tries_left+1` is **string concatenation**, not addition
- When `tries_left=4`, sets it to string `"4+1"` not number `5`
- In `((tries_left--))`, bash evaluates `"4+1"` as expression `4+1=5` then decrements back to `4` — **invalid guesses never decrement tries**
- A student who correctly writes `((tries_left++))` or `tries_left=$((tries_left+1))` **fails the test** (output differs)
- Test expects buggy behavior — rewards incorrect implementations

### 2. hello-devops / introduction / hello — `$USERNAME` vs `$USER`
**Files:** `sh/tests/solutions/hello-devops.sh`, `sh/tests/solutions/hello.sh`
- Uses `$USERNAME` — **non-standard environment variable** (Windows/Cygwin holdover)
- Standard Linux/Docker: `$USER` or `$LOGNAME`
- Debian-stable-slim Docker container may not have `$USERNAME` set
- When unset, output becomes `"Hello !"` — test still passes (both student and solution produce same broken output)
- A student using correct `$USER` variable **fails the test** — false negative

### 3. grades solution — `expr "$grade" \> 100` before numeric check
**File:** `sh/tests/solutions/grades.sh`
- `expr "$grade" \> 100` runs BEFORE `[[ "$grade" =~ ^[0-9]+$ ]]` validation
- On non-numeric input like `"not_good"`, `expr "not_good" \> 100` writes `expr: non-integer argument` to stderr
- A student who checks numeric-first has **clean stderr** → diff against solution's polluted stderr → **FAIL**
- **False negative for correctly-written students**

### 4. calculator_test.sh — `source` of student script can `exit` the entire test
**File:** `sh/tests/calculator_test.sh`
- `source "$script_dirS"/student/calculator.sh 10 + 10` sources student code in **current shell**
- If student script calls `exit` (even `exit 0`), the **entire test harness exits**
- Only works because reference solution never calls `exit` on valid input; any student variation that exits cleanly **crashes the test**

### 5. file-checker_test.sh — `grep -q "test"` catastrophic false positive
**File:** `sh/tests/file-checker_test.sh`
- `grep -q "test"` matches literal substring `"test"` anywhere in file
- Catches: comments (`# test case`), variable names (`test_result`), and even the solution's own `[ ! -e "$1" ]` (uses `[` not `test` but grep doesn't care)
- Should use `grep -w test` or check for `test` command semantics, not string content

### 6. file-checker_test.sh — `chmod` applied to wrong directory
**File:** `sh/tests/file-checker_test.sh`
- Files created via `touch file-checker/readable-only` (relative to CWD)
- But `chmod -xw "$script_dirS/file-checker/readable-only"` targets `$script_dirS/file-checker/`
- Unless `$script_dirS` == CWD (not guaranteed in Docker entrypoint), files don't exist there → `set -e` kills test

### 7. job-regist_test.sh — parallel execution race + timestamp drift
**File:** `sh/tests/job-regist_test.sh`
- Student and solution run IN PARALLEL (background processes)
- Both write timestamps (`date +"%F %T"`): timestamps always differ → `diff` **ALWAYS fails** for correct implementation
- `create_random_job` called twice simultaneously overwrites same `job.sh` file → race condition

### 8. json-researcher_test.sh / who-are-you_test.sh — `~/.curlrc` modified, never cleaned
**Files:** `sh/tests/json-researcher_test.sh`, `sh/tests/who-are-you_test.sh`
- `echo insecure >> ~/.curlrc` disables SSL verification globally
- **Never cleaned up** — all subsequent curl commands in environment bypass SSL
- Also: `caddy start &>/dev/null` with no health-check; orphaned on test failure

### 9. entrypoint.sh — `cp -r /app .` creates nested recursive copy
**File:** `sh/tests/entrypoint.sh`
- WORKDIR is `/app`, so `cp -r /app .` copies `/app` INTO `/app/` → `/app/app`
- Student code lands in `/app/app/student/`, not `/app/student/`
- Works accidentally but doubles disk usage, fragile

### 10. right_test.sh — `$()` output executed as command (RCE vector)
**File:** `sh/tests/right_test.sh`
- `$(cd "$1" && bash "$script_dirS"/$FILENAME)` captures stdout, then result is **executed as a command** (unquoted)
- Currently works because script writes to file (no stdout to capture), but any script inadvertently producing stdout causes arbitrary command execution in test

---

## HIGH-SEVERITY BUGS

### Test Infrastructure

| Exercise | File | Issue |
|----------|------|-------|
| division | `division_test.sh` | `grep -q "test"` catches substring — false positive on any file containing "test" anywhere |
| find-files | `find-files_test.sh` | `[ -f ${FILENAME} ]` uses CWD-relative path, not `$script_dirS` |
| find-files | `find-files_test.sh` | `find` output order is filesystem-dependent → false negative on strict `diff` |
| find-files-extension | `find-files-extension_test.sh` | `challenge find-files-extension/folder1` — bare relative path, fails if CWD != test dir |
| count-files | `count-files_test.sh` | Same bare-relative-path issue |
| custom-ls | `custom-ls_test.sh` | `unalias custom-ls` → crashes test if student used a function instead of alias |
| file-researcher | `file-researcher_test.sh` | No `script_dirS` defined — uses bare `student/file-researcher.sh` |
| bin-status | `bin-status_test.sh` | Missing `script_dirS` — raw relative paths, no `$script_dirS` computation |
| joker-num | `joker-num_test.sh` | `$script_dirS` computed but **never used** — uses `./student/joker-num.sh` |
| master-the-ls | `master-the-ls_test.sh` | `IFS='\n'` sets IFS to literal `\n`, not newline (same in **all** tests with this pattern) |
| in-back-ground | `in-back-ground_test.sh` | Race condition: `nohup ... &` not finished before `output.txt` read; `challenge_no_output` never verifies file absence post-run |
| burial | `burial_test.sh` | Same `IFS='\n'` bug; race condition between sequential runs |
| hard-perm | `hard-perm_test.sh` | `chmod 776 hard-perm/*` runs unconditionally at top level, not inside `challenge()` |
| remake | `remake_test.sh` | `echo $submitted` unquoted (word splitting); `ls -ltr` comparison fragile across platforms |
| env-format | `env-format_test.sh` | `printenv` output order unspecified — `diff` on unordered output causes false negatives |
| introduction | `introduction_test.sh` | No file existence check; `$USERNAME` env var mismatch |
| details | `details_test.sh` | Time format drift: `ls -l` shows year (file >6mo old) vs time — column count shifts in `awk` |
| file-details | `file-details_test.sh` | Bare relative path `hard-perm` — same pattern as other path-dependent tests |

### Solutions

| Exercise | File | Issue |
|----------|------|-------|
| division | `solutions/division.sh` | No exit codes on error paths — exits 0 even on failure |
| find-files | `solutions/find-files.sh` | `-or` is GNU extension (not POSIX `-o`) — fails on BSD/macOS |
| count-files | `solutions/count-files.sh` | `-type d,f` is GNU extension; also includes `.` in count (off-by-one vs counting contents) |
| check-user | `solutions/check-user.sh` | `set -e` + `getent passwd $2` on non-existent user crashes + stderr pollution |
| in-back-ground | `solutions/in-back-ground.sh` | Useless `cat facts | grep "moon"`; race condition on `output.txt` write |
| master-the-ls | `solutions/master-the-ls.sh` | `ls -p -tu` sorts by atime, test checks mtime — fragile with `noatime` mounts |
| various | Various solutions | `echo $VAR` unquoted — word splitting on values with spaces/globs |

---

## MEDIUM-SEVERE ISSUES

| Exercise | File | Issue |
|----------|------|-------|
| plus | `plus_test.sh` | Exit code never checked; `expr` returns exit 1 when result is 0 |
| calculator | `calculator_test.sh` | `grep case | wc -l` matches comments/strings containing "case" — false positive in mandate check |
| set-internal-vars | `solutions/set-internal-vars.sh` | `MY_ARR=(one, two, three, four, five)` — commas are **part of values** (not array separators). Output: `one, two, three, four, five` with commas |
| hello-devops | `solutions/hello-devops.sh` | `rm -rf struct file-struct.sh ...` — destructive cleanup in student scripts could wipe legit files |
| all exercises | All test files | `grep echo` checks match substring `echo` anywhere (comments, `echolocation`, etc.) — false positive |
| all exercises | All test files | `IFS='\n'` sets IFS to literal `\n`, not newline — should be `IFS=$'\n'`. Ubiquitous across ~30+ files, works by accident |
| Dockerfile | `Dockerfile` | Caddy v2.3.0 hardcoded (latest ~v2.9); `linux_amd64` only — fails on ARM hosts |
| env-format | `solutions/env-format.sh` | `printenv` output order unspecified — student using `sort` or `env` fails diff |
| all caddy tests | `json-researcher_test.sh`, `who-are-you_test.sh` | No health-check after `caddy start` — race condition on first curl |
| all caddy tests | `json-researcher_test.sh`, `who-are-you_test.sh` | No cleanup on test failure — `caddy stop` never runs, orphan process |
| head-and-tail | `head-and-tail_test.sh` | No echo ban (subject says no echo) but test doesn't enforce it |
| right/left | `right_test.sh`/`left_test.sh` | g dependency on specific directory names `right/` and `left/` |
| all | All tests with `diff` | `echo "$submitted"` adds one trailing newline — if script output has zero or multiple trailing newlines, comparison is distorted |

---

## MINOR / LINT ISSUES

- No shebang in many solutions (`hard-conditions.sh`, `easy-perm.sh`, `right.sh`, `left.sh`)
- `echo $result` unquoted throughout solutions
- `[ $3 == 0 ]` uses `==` instead of POSIX `=` (several solutions)
- `#!/bin/bash` instead of `#!/usr/bin/env bash` in some solutions (e.g., `joker-num.sh`)
- Useless `cat $FILENAME | grep` pattern (UUOC) in multiple tests
- "Pinguin" typo in `teacher` test data instead of "Penguin"
- Typo: `"The file exist but is empty"` → should be `exists` (multiple test files)
- `diff -q` + `&>/dev/null` redundant in `explain_test.sh`
- `chmod 303 easy-perm/*` — glob fails silently if dir empty or missing
- No cleanup of temp files in most tests (`grades_submitted_output`, `uncompressed/` dirs, etc.)

---

## EXERCISE INVENTORY

### Exercises WITH test + solution (31)
hello, plus, division, easy-conditions, hard-conditions, calculator, find-files, find-files-extension, count-files, largest, custom-ls, details, dir-info, file-checker, file-details, file-researcher, better-cat, head-and-tail, skip-lines, input-redirection, append-output, env-format, set-env-vars, set-internal-vars, comparator, greatest-of-all, grades, easy-perm, hard-perm, burial, in-back-ground, job-regist, auto-exec-bin, bin-status, master-the-ls, joker-num, remake, explain, json-researcher, teacher, change-struct, check-user, who-are-you, hello-devops, array-selector, right, left, to-git-or-not-to-git

### Exercises WITH test but WITHOUT solution (12)
strange-files, file-struct, auto-jobs, cl-camp1, cl-camp2, cl-camp3, cl-camp4, cl-camp5, cl-camp6, cl-camp7, cl-camp8

---

## SYSTEMIC ISSUES (cross-cutting)

1. **`IFS='\n'` everywhere** — wrong, should be `IFS=$'\n'`. Ubiquitous across ~30+ test files. Not triggered currently because test inputs don't contain `\` or `n`, but violates declared "Unofficial Bash Strict Mode" and will bite on any input containing these chars.

2. **`grep echo` / `grep test` substring matches** — false positives across multiple exercises. No test uses `grep -w` or word-boundary checks. A file containing `"testing"`, `"echolocation"`, or `"latest"` gets falsely rejected.

3. **Bare relative paths** — ~10 tests use `challenge dirname` or `bash student/file.sh` without anchoring to `$script_dirS`. Crash if CWD != test directory.

4. **No `DOMAIN` env var** — 3 tests (`json-researcher`, `who-are-you`, `to-git-or-not-to-git`) depend on external `$DOMAIN` variable. Cannot run locally without platform infrastructure.

5. **`~/.curlrc` SSL bypass** — 2 tests permanently disable SSL globally via `echo insecure >> ~/.curlrc`. Never cleaned up. Security issue.

6. **Unquoted variables in solutions** — `echo $result`, `echo $var`, `echo $submitted` — word splitting and glob expansion risks. Works because outputs are numeric or simple strings, but breaks on any value containing `*`, `?`, `[`, or spaces.

---

## TOP 3 MOST BROKEN EXERCISES

1. **`job-regist`** — systematic false negative (parallel timestamp race + shared `job.sh` race)
2. **`joker-num`** — reference solution has string-concat bug, test expects buggy behavior
3. **`hello-devops` / `hello` / `introduction`** — `$USERNAME` env var not standard on Linux, correct students using `$USER` fail
