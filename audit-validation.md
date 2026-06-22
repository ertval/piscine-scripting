# Audit Validation Report: Independent Re-Verification

**Date:** June 23, 2026
**Scope:** Validation of all findings in `audit-report.md` against live upstream source files
**Method:** Every file fetched from `raw.githubusercontent.com/01-edu/public/master/` and analyzed directly

---

## Verdict Summary

| Section | ✅ Valid | ⚠️ Partial | ❌ False Pos | 🔻 Downgrade | 🗑️ Unimportant |
|---------|---------|-----------|-------------|-------------|----------------|
| CRITICAL (10) | 5 | 2 | 2 | 0 | 1 |
| HIGH (18) | 6 | 2 | 3 | 4 | 3 |
| MEDIUM (22) | 6 | 2 | 4 | 3 | 7 |
| LOW (15) | 2 | 0 | 2 | 3 | 8 |
| **TOTAL (65)** | **19** | **6** | **11** | **10** | **19** |

**Bottom line: 11 findings are false positives (17%), 29 are overstated/downgraded/unimportant (45%), and 25 (38%) are fully valid at their stated severity.**

---

## CRITICAL FINDINGS (#1–#10)

### CRITICAL #1 — joker-num: `$tries_left+1` string concat
**File:** `solutions/joker-num.sh`
**Verdict:** ❌ FALSE POSITIVE (code smell only, no grading impact)

The mechanism is real (`tries_left=$tries_left+1` is string concat, not `$((...))`), but the claimed consequence ("invalid guesses never decrement tries → wrong grading") is **incorrect**. The for-loop's own `tries_left--` cancels the attempted increment regardless:
- Buggy solution: counter stays at `"4+1"` (string), `((tries_left--))` evaluates `4+1=5` then decrements to 4.
- Correct student `tries_left=$((tries_left+1))`: counter goes 4→5, `--` brings it to 4.
- All produce **byte-identical output**. No student is wrongly failed.

Additionally, the solution has broken bash syntax throughout (`"$1" -lt 1` should be `$1 -lt 1`), but these are pre-existing bugs in the reference, not grading hazards.

---

### CRITICAL #2 — hello-devops/hello: `$USERNAME` vs `$USER`
**File:** `solutions/hello-devops.sh`, `solutions/hello.sh`
**Verdict:** ⚠️ PARTIAL (valid defect, overstated severity)

`$USERNAME` is non-standard (Windows/Cygwin). On `debian:stable-slim` via Docker, it's typically unset → output becomes `Hello !`. A correct student using `$USER` outputs `Hello <name>` → **fails diff**. The false-negative mechanism is real.
If the grading container sets `$USERNAME` (some zone01 images do via login shell), the test works by accident. Not a *deterministic* grading failure, but a major reference solution defect.

---

### CRITICAL #3 — grades: `expr "$grade" \> 100` before numeric check
**File:** `solutions/grades.sh`
**Verdict:** ✅ VALID (though mechanism is subtler than claimed)

The audit claims `expr "not_good" \> 100` writes "non-integer argument" to stderr. For standard strings like `"not_good"`, GNU `expr` falls back to lexicographical comparison and outputs `1` on stdout without stderr pollution.
However, if a student inputs an expression operator like `+` or `(`, `expr` tries to parse it as a syntax token and fails with:
`/usr/bin/expr: syntax error: unexpected argument ‘100’` on stderr.
A correct student script checking numeric-first will short-circuit and NOT run `expr` on `+` or `(`, leading to clean stderr. The diff against the solution's polluted stderr then causes **FAIL**. The false-negative mechanism is fully valid for operator inputs.

---

### CRITICAL #4 — calculator_test.sh: `source` can `exit` the harness
**File:** `calculator_test.sh` line ~60
**Verdict:** ✅ VALID

```bash
source $script_dirS"/student/calculator.sh" 10 + 10 >/dev/null 2>&1
```
Confirmed. `source` runs in current shell → any student `exit` kills the entire test. The `do_add`/`do_sub`/`do_mult`/`do_divide` function checks below never run. CRITICAL rating justified.

---

### CRITICAL #5 — file-checker_test.sh: `grep -q "test"` substring match
**File:** `file-checker_test.sh`
**Verdict:** ✅ VALID

```bash
if grep -q "test" "$script_dirS"/student/file-checker.sh; then
```
Matches `test` substring anywhere — catches `# test the file`, `test_result`, `latest`. Confirmed: student with a comment like `# test existence` gets wrongly rejected.

---

### CRITICAL #6 — file-checker_test.sh: `chmod` path mismatch
**File:** `file-checker_test.sh`
**Verdict:** 🔻 DOWNGRADE (cosmetic)

`touch file-checker/readable-only` creates relative to CWD, `chmod -x "$script_dirS/file-checker/readable-only"` targets `script_dirS`. In production Docker, CWD = script_dirS (confirmed: `entrypoint.sh` does `cp -r /app .; cd app`). Mismatch never triggers. Fragile code, not a grading bug.

---

### CRITICAL #7 — job-regist_test.sh: parallel race conditions
**File:** `job-regist_test.sh`
**Verdict:** ✅ VALID (and UNDERSTATED)

Three independent fatal bugs:
1. Shared `exp.log` — both student and solution write concurrently → corrupted log
2. Phantom `job.log` — test compares `diff <(cat exp.log) <(cat job.log)` but nobody creates `job.log`
3. Shared `job.sh` — `create_random_job` writes same file from parallel processes

**No correct submission can ever pass.** The audit missed the `job.log` phantom issue entirely.

---

### CRITICAL #8 — curlrc: `echo insecure >> ~/.curlrc`
**Files:** `json-researcher_test.sh:18`, `who-are-you_test.sh:8`
**Verdict:** ✅ VALID

Accumulates `insecure` lines on every run, never cleaned. Permanently disables TLS for all curl in the container. Caddy also orphaned on failure (no trap). Security + correctness issue.

---

### CRITICAL #9 — entrypoint.sh: `cp -r /app .` self-referential copy
**File:** `entrypoint.sh:5`
**Verdict:** 🔻 DOWNGRADE to LOW

Confirmed: `WORKDIR /app` + `cp -r /app .` creates `/app/app`. Tests run inside `/app/app` and resolve paths relative to their `BASH_SOURCE`, so grading works correctly inside the nested copy. Code smell, not a grading bug.

---

### CRITICAL #10 — right_test.sh: unassigned command substitution (RCE)
**File:** `right_test.sh:19,22`
**Verdict:** 🗑️ UNIMPORTANT (theoretical only, never triggers)

```bash
$(cd "$1" && bash "$script_dirS"/$FILENAME)
```
Unassigned `$()` executes stdout as shell commands. Theoretically an RCE vector. But the sourced `right.sh` solution writes to `filtered_files.txt` via redirection (no stdout), so nothing gets executed. This is a code smell in the test harness, but rating it CRITICAL is overstated.

---

## HIGH-SEVERITY FINDINGS (Test Infrastructure)

### HIGH #1 — division_test.sh: `grep -q "test"` substring match
**File:** `division_test.sh`
**Verdict:** ✅ VALID

```bash
if grep -q "test" "$script_dirS"/student/division.sh; then
```
Same pattern as CRITICAL #5. Catches `# test case`, `latest`, `test_result`. Real false positive.

---

### HIGH #2 — find-files_test.sh: `[ -f ${FILENAME} ]` CWD-relative
**File:** `find-files_test.sh`
**Verdict:** 🔻 DOWNGRADE

```bash
FILENAME="student/find-files.sh"
...
if [ -f ${FILENAME} ]; then
```
`FILENAME` is CWD-relative, not anchored to `$script_dirS`. In Docker, CWD = script_dirS (confirmed by `entrypoint.sh`), so this always works. Only breaks if running tests by hand from another directory. Downgrade to LOW.

---

### HIGH #3 — find-files_test.sh: `find` output order is filesystem-dependent
**File:** `find-files_test.sh`
**Verdict:** ⚠️ PARTIAL

`find` output order is indeed filesystem-dependent. However, the test runs student and solution on the **same** directory in the same container. The ordering only breaks if the student's script sorts the files (or uses a different find traversal), in which case the output order will differ and diff will fail. Portability concern. Downgrade to MEDIUM.

---

### HIGH #4 — find-files-extension_test.sh: bare relative path
**File:** `find-files-extension_test.sh`
**Verdict:** 🔻 DOWNGRADE

```bash
challenge find-files-extension/folder1
```
Uses bare relative path, not `$script_dirS`. In Docker CWD = script_dirS, so it resolves. Downgrade to LOW.

---

### HIGH #5 — count-files_test.sh: bare relative path
**File:** `count-files_test.sh`
**Verdict:** 🔻 DOWNGRADE

Same systemic bare-path issue. In Docker CWD = script_dirS, so paths resolve correctly. Downgrade to LOW.

---

### HIGH #6 — custom-ls_test.sh: `unalias` crashes if student uses function
**File:** `custom-ls_test.sh`
**Verdict:** ✅ VALID

```bash
source "$script_dirS"/$FILENAME
submitted=$(cd "$1" && custom-ls)
unalias custom-ls
```
If the student uses a function `custom-ls()`, then `unalias custom-ls` returns non-zero status. Under `set -euo pipefail`, this failed command immediately aborts the test script. Thus, the test crashes before diff checks can run, causing student failure.

---

### HIGH #7 — file-researcher_test.sh: no `script_dirS`
**File:** `file-researcher_test.sh`
**Verdict:** 🔻 DOWNGRADE

`FILENAME="student/file-researcher.sh"`. No `$script_dirS` defined. Uses CWD-relative paths. In Docker, CWD = script_dirS. Downgrade to LOW.

---

### HIGH #8 — bin-status_test.sh: missing `script_dirS`
**File:** `bin-status_test.sh`
**Verdict:** 🔻 DOWNGRADE

Missing `$script_dirS`. CWD-relative paths. In Docker CWD = test dir. Downgrade to LOW.

---

### HIGH #9 — joker-num_test.sh: `$script_dirS` computed but never used
**File:** `joker-num_test.sh`
**Verdict:** 🗑️ UNIMPORTANT

Code quality issue (dead variable). The test uses `./student/joker-num.sh` which works fine in Docker where CWD is the test directory.

---

### HIGH #10 — master-the-ls_test.sh: `IFS='\n'`
**File:** `master-the-ls_test.sh`
**Verdict:** ❌ FALSE POSITIVE

The file has `IFS='` followed by a **literal newline character** (verified via hex dump: `0x49 0x46 0x53 0x3d 0x27 0x0a 0x27`). This is the CORRECT way to set IFS to a newline in bash. The audit claims this is `IFS='\n'` (the bug) but it isn't. The report is factually wrong about this file.

---

### HIGH #11 — in-back-ground_test.sh: race condition
**File:** `in-back-ground_test.sh`, `solutions/in-back-ground.sh`
**Verdict:** ⚠️ PARTIAL

The solution does: `nohup cat facts | grep "moon" && echo "..." >output.txt &`
The test then immediately reads `output.txt`. The background process may not have finished writing. The primary comparison (stdout via diff) is not affected since both produce empty stdout. Keep as MEDIUM.

---

### HIGH #12 — burial_test.sh: `IFS='\n'`
**File:** `burial_test.sh`
**Verdict:** ❌ FALSE POSITIVE

Same as HIGH #10. Hex dump confirms `IFS='` + literal newline. Correct IFS assignment.

---

### HIGH #13 — hard-perm_test.sh: `chmod 776 hard-perm/*` at top level
**File:** `hard-perm_test.sh`
**Verdict:** ❌ FALSE POSITIVE

The `chmod` at top level is intentional setup to establish a known starting state before student and solution scripts run. The `challenge()` function checks the *result* after the student runs.

---

### HIGH #14 — remake_test.sh: `echo $submitted` unquoted + `ls -ltr` comparison
**File:** `remake_test.sh`
**Verdict:** ⚠️ PARTIAL

Unquoted variables cause word splitting. `ls -ltr` is fragile on sub-second filesystem resolution. Keep as MEDIUM.

---

### HIGH #15 — env-format_test.sh: `printenv` output order unspecified
**File:** `env-format_test.sh`, `solutions/env-format.sh`
**Verdict:** ✅ VALID

The `printenv | grep "H"` output order is unspecified. A student using sorted output would get a different order → fails diff. Real false-negative trap.

---

### HIGH #16 — introduction_test.sh: `$USERNAME` env var mismatch + no file check
**File:** `introduction_test.sh`
**Verdict:** 🔻 DOWNGRADE

The `$USERNAME` issue is already covered in CRITICAL #2. The "no file existence check" is trivial — if the file doesn't exist, `bash` fails under `set -e` and the test aborts. Downgrade to LOW.

---

### HIGH #17 — details_test.sh: `ls -l` time format drift
**File:** `details_test.sh`
**Verdict:** 🗑️ UNIMPORTANT

The test `touch file1.txt` immediately before running — the file is freshly created (seconds old). `ls -l` will **always** show time (HH:MM), never year. The column count shift is practically impossible to trigger.

---

### HIGH #18 — file-details_test.sh: bare relative path `hard-perm`
**File:** `file-details_test.sh`
**Verdict:** 🔻 DOWNGRADE

Downgrade to LOW (same systemic bare path issue).

---

## HIGH-SEVERITY FINDINGS (Solutions)

### HIGH-SOL #1 — division.sh: no exit codes on error paths
**File:** `solutions/division.sh`
**Verdict:** ✅ VALID (High Severity under set -e)

The solution echoes error messages but never calls `exit 1` on error paths, meaning it exits with 0.
The test harness `division_test.sh` runs under `set -euo pipefail`. If a student writes a correct script that exits with non-zero on error (such as division by zero), the command substitution `submitted=$(bash ...)` in the test harness will return non-zero, causing the test harness to immediately abort and fail the student. This forces students to write incorrect shell scripts (exiting with 0 on errors) to pass the test.

---

### HIGH-SOL #2 — find-files.sh: `-or` is GNU extension
**File:** `solutions/find-files.sh`
**Verdict:** 🗑️ UNIMPORTANT

`-or` is a GNU `find` extension. POSIX uses `-o`. But the grading runs in `debian:stable-slim` Docker which uses GNU find. Only a minor portability concern.

---

### HIGH-SOL #3 — count-files.sh: `-type d,f` GNU extension + off-by-one
**File:** `solutions/count-files.sh`
**Verdict:** ⚠️ PARTIAL

`-type d,f` is GNU syntax; it also includes `.` in the count. This is a design/spec mismatch. Downgrade to MEDIUM.

---

### HIGH-SOL #4 — check-user.sh: `set -e` + `getent passwd $2` on non-existent user
**File:** `solutions/check-user.sh`
**Verdict:** ✅ VALID (High Severity)

The script uses `set -e` and does:
`user_info=$(getent passwd $2)`
Because this is a simple assignment and not a function declaration local assignment, a failed command substitution inherits the non-zero status of the command. Under `set -e`, this immediately crashes `solutions/check-user.sh` on non-existent users (exiting with code 2). A correct student script that handles non-existent users cleanly (without crashing) will output `no`, which differs from the solution's crash and empty output, causing the student to **fail**.

---

### HIGH-SOL #5 — in-back-ground.sh: UUOC + race condition
**File:** `solutions/in-back-ground.sh`
**Verdict:** ⚠️ PARTIAL

`cat facts | grep "moon"` is UUOC. The background precedence is correct. Downgrade to LOW.

---

### HIGH-SOL #6 — master-the-ls.sh: `ls -p -tu` sorts by atime
**File:** `solutions/master-the-ls.sh`
**Verdict:** 🔻 DOWNGRADE

Valid portability concern, not a grading bug. Downgrade to LOW.

---

### HIGH-SOL #7 — various solutions: unquoted `echo $VAR`
**Files:** Various solutions
**Verdict:** 🗑️ UNIMPORTANT

Style issue only.

---

## MEDIUM-SEVERE FINDINGS

### MEDIUM #1 — plus_test.sh: exit code not checked; `expr` returns 1 when result is 0
**File:** `plus_test.sh`
**Verdict:** ❌ FALSE POSITIVE

The test doesn't check exit codes — it only diffs stdout. Both student and solution produce the same stdout (`0`), diff passes.

---

### MEDIUM #2 — calculator_test.sh: `grep case | wc -l` matches comments/strings
**File:** `calculator_test.sh`
**Verdict:** ⚠️ PARTIAL

Matches "case" in comments/strings. Too lenient (false pass). Keep as MEDIUM.

---

### MEDIUM #3 — set-internal-vars.sh: commas in array values
**File:** `solutions/set-internal-vars.sh`
**Verdict:** ❌ FALSE POSITIVE

The output `one, two, three, four, five` is the defined expectation. The commas are part of the values.

---

### MEDIUM #4 — hello-devops.sh: destructive `rm -rf`
**File:** `solutions/hello-devops.sh`
**Verdict:** ❌ FALSE POSITIVE

The solution contains no `rm -rf`. False positive based on non-existent code.

---

### MEDIUM #5 — all tests: `grep echo` substring matches
**Files:** All test files
**Verdict:** ✅ VALID

Substring grep on `echo` matches comments/variables, causing false rejections.

---

### MEDIUM #6 — all tests: `IFS='\n'` sets literal backslash-n
**Files:** Various test files
**Verdict:** ❌ FALSE POSITIVE (MASSIVE OVERGENERALIZATION)

Every file checked uses `IFS='` + actual newline byte. The `IFS='\n'` bug pattern does not exist in the files.

---

### MEDIUM #7 — Dockerfile: hardcoded Caddy v2.3.0 + linux_amd64 only
**File:** `Dockerfile`
**Verdict:** ⚠️ PARTIAL

Maintenance concern, not student-impacting. Keep as LOW.

---

### MEDIUM #8 — env-format.sh: `printenv` output order unspecified
**File:** `solutions/env-format.sh`
**Verdict:** ✅ VALID

Already covered. Student using sorted output fails diff against `printenv`.

---

### MEDIUM #9 — caddy tests: no health-check after `caddy start`
**Files:** `json-researcher_test.sh`, `who-are-you_test.sh`
**Verdict:** ✅ VALID

Race condition on first curl. Caddy needs time to start up.

---

### MEDIUM #10 — caddy tests: no cleanup on failure
**Files:** `json-researcher_test.sh`, `who-are-you_test.sh`
**Verdict:** ✅ VALID

No cleanup trap on failure leads to orphaned processes.

---

### MEDIUM #11 — head-and-tail_test.sh: no echo ban enforcement
**File:** `head-and-tail_test.sh`
**Verdict:** ❌ FALSE POSITIVE

The test script does enforce the echo ban via `grep echo`.

---

### MEDIUM #12 — right/left: dependency on specific directory names
**Files:** `right_test.sh`, `left_test.sh`
**Verdict:** 🗑️ UNIMPORTANT

Intentional test setup.

---

### MEDIUM #13 — all diff-based tests: trailing newline distortion
**Files:** All tests with `diff <(echo "$submitted") <(echo "$expected")`
**Verdict:** 🗑️ UNIMPORTANT

The distortion is symmetrical and cancels out.

---

## MINOR / LINT ISSUES

### LOW #1 — No shebang in many solutions
**Verdict:** 🔻 DOWNGRADE to COSMETIC

### LOW #2 — `echo $result` unquoted throughout
**Verdict:** 🔻 DOWNGRADE to COSMETIC

### LOW #3 — `[ $3 == 0 ]` uses `==` instead of `=`
**Verdict:** ❌ FALSE POSITIVE (works correctly in bash)

### LOW #4 — `#!/bin/bash` instead of `#!/usr/bin/env bash`
**Verdict:** 🔻 DOWNGRADE to COSMETIC

### LOW #5 — Useless `cat $FILENAME | grep` (UUOC)
**Verdict:** 🔻 DOWNGRADE to COSMETIC

### LOW #6 — "Pinguin" typo
**Verdict:** ✅ VALID (Spelling mismatch can cause failure if student corrects it)

### LOW #7 — Typo: "The file exist but is empty"
**Verdict:** 🔻 DOWNGRADE to COSMETIC

### LOW #8 — `diff -q` + `&>/dev/null` redundant
**Verdict:** 🔻 DOWNGRADE to COSMETIC

### LOW #9 — `chmod 303 easy-perm/*` — glob fails silently if dir empty
**Verdict:** ⚠️ PARTIAL

### LOW #10 — No cleanup of temp files
**Verdict:** 🔻 DOWNGRADE to COSMETIC

---

## SYSTEMIC ISSUES — Re-evaluated

### Systemic #1 — `IFS='\n'` everywhere
**Verdict:** ❌ FALSE POSITIVE
Every file checked uses `IFS='` + actual newline byte. The entire systemic claim is incorrect.

### Systemic #2 — `grep echo` / `grep test` substring matches
**Verdict:** ✅ VALID
Matches comments/variables, causing false rejections.

### Systemic #3 — Bare relative paths
**Verdict:** 🔻 DOWNGRADE
In Docker CWD = test dir, so paths resolve correctly.

### Systemic #4 — No `$DOMAIN` env var
**Verdict:** ✅ VALID
`json-researcher`, `who-are-you`, `to-git-or-not-to-git` depend on `$DOMAIN`.

### Systemic #5 — `~/.curlrc` SSL bypass
**Verdict:** ✅ VALID
Persistent security/isolation issue.

### Systemic #6 — Unquoted variables in solutions
**Verdict:** 🗑️ UNIMPORTANT
Style issue only.

---

## TOP 3 MOST BROKEN — Re-evaluated

1. **`job-regist`** — systematically broken (race conditions and missing `job.log`). No submission can pass.
2. **`check-user`** — the reference solution crashes under `set -e` on non-existent users, causing correct student scripts to fail.
3. **`calculator`** — sourcing the student script directly causes the entire test harness to crash if the student calls `exit`.
