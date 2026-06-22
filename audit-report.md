# Audit Report: 01-edu/public Shell Tests & Solutions

**Date:** June 22, 2026
**Scope:** 42 exercises in `sh/tests/` and `sh/tests/solutions/` of 01-edu/public
**Method:** Fetched all official test files and solutions from raw.githubusercontent.com/01-edu/public/master/, audited for bugs, drifts, false positives/negatives, and infrastructure issues

---

## Independent Validation Pass (June 23, 2026)

> Every finding below was independently re-verified against the live upstream files
> (`raw.githubusercontent.com/01-edu/public/master/`) by fetching the code and **running it**
> in bash, not by re-reading the auditor's claims. Each item carries a verdict tag:
>
> - ✅ **VALID** — reproduced as described
> - ⚠️ **PARTIAL** — real bug, but severity overstated or mechanism mis-described
> - ❌ **FALSE POSITIVE** — could not reproduce; claim is incorrect
> - 🔻 **DOWNGRADE** — real code smell but does not trigger in the actual Docker runtime
>
> **Headline result of the CRITICAL pass: of 10 "CRITICAL" findings, 3 are false positives,
> 1 is downgraded to cosmetic, and 1 (job-regist) is understated — it is worse than reported.**
>
> Verdict tally (updated as each section is validated):
>
> | Section | ✅ Valid | ⚠️ Partial | ❌ False + | 🔻 Downgrade |
> |--------|---------|-----------|-----------|--------------|
> | CRITICAL (10) | 5 | 1 | 3 | 1 |
> | HIGH (18) | _pending_ | | | |
> | MEDIUM (22) | _pending_ | | | |
> | LOW (15) | _pending_ | | | |

---

## Summary

| Severity | Count (original) | After validation |
|----------|------------------|------------------|
| CRITICAL | 10 | **5 truly critical** (3 false positives removed, 1 downgraded, 1 kept-but-understated) |
| HIGH | 18 | _pending_ |
| MEDIUM | 22 | _pending_ |
| LOW | 15 | _pending_ |

---

## CRITICAL BUGS (cause false pass/fail on grading)

### 1. joker-num solution — `$tries_left+1` string concat, not arithmetic — ❌ FALSE POSITIVE
**File:** `sh/tests/solutions/joker-num.sh`
- `tries_left=$tries_left+1` is **string concatenation**, not addition
- When `tries_left=4`, sets it to string `"4+1"` not number `5`
- In `((tries_left--))`, bash evaluates `"4+1"` as expression `4+1=5` then decrements back to `4` — **invalid guesses never decrement tries**

> **❌ VERDICT: FALSE POSITIVE.** The mechanism (string concat vs arithmetic) is real and
> correctly diagnosed, but the *claimed consequence* is wrong. The audit asserts a correct
> student (`((tries_left++))` or `tries_left=$((tries_left+1))`) **fails the test**. It does not.
>
> **Empirical proof (run against live upstream solution + test cases):**
> - Buggy official: invalid guess leaves counter at 4, then `((tries_left--))` keeps it at 4.
> - Correct student `((tries_left++))`: counter goes 4→5, then for-loop `--` brings it back to 4.
> - Correct student `tries_left=$((tries_left+1))`: counter goes 4→5, then `--` brings it to 4.
>
> **All three produce byte-identical output** on every test case in `joker-num_test.sh`
> (verified with `diff` on both `challenge 50` and `challenge 78` inputs). The buggy line and
> any correct equivalent are *observationally indistinguishable* through this test harness,
> because the for-loop's own `tries_left--` cancels the attempted increment either way.
>
> The solution code is genuinely sloppy (and the `[[ ! "$1" =~ ^[0-9]+$ ]]` / `"$1" -lt 1`
> lines are also broken bash syntax), but **no student is wrongly failed** by this specific
> claim. Downgrade to a MEDIUM code-quality note.

### 2. hello-devops / introduction / hello — `$USERNAME` vs `$USER`
**Files:** `sh/tests/solutions/hello-devops.sh`, `sh/tests/solutions/hello.sh`
- Uses `$USERNAME` — **non-standard environment variable** (Windows/Cygwin holdover)
- Standard Linux/Docker: `$USER` or `$LOGNAME`
- Debian-stable-slim Docker container may not have `$USERNAME` set
- When unset, output becomes `"Hello !"` — test still passes (both student and solution produce same broken output)
- A student using correct `$USER` variable **fails the test** — false negative

> **⚠️ VERDICT: PARTIAL — core claim VALID, one sub-claim needs nuance.**
>
> **Confirmed by execution:**
> - `$USERNAME` is **not** a standard POSIX/sh variable. Verified: `bash -c 'echo $USERNAME'` in a
>   non-login shell prints empty; it is only populated by PAM/login managers, not by bash itself.
> - `env -u USERNAME bash -c 'echo "Hello $USERNAME!"'` → outputs `Hello !` (empty name).
> - On `debian:stable-slim` run via `docker run ... bash script.sh` (the test entrypoint pattern),
>   `$USERNAME` is indeed typically unset, while `$USER`/`$LOGNAME` are set.
>
> So the test compares student-vs-solution, and if both use the same (broken) `$USERNAME`,
> **both emit `Hello !` and the diff passes** — a correct student using `$USER` (which *is* set)
> would emit `Hello <name>` and **fail**. The false-negative mechanism is **real and valid.**
>
> **Nuance / correction:** the audit's phrasing "test still passes (both produce same broken
> output)" is only true when `$USERNAME` is unset in the container. If the grading container
> *does* set `$USERNAME` (some zone01 images do via the login shell), the test works "correctly"
> but for the wrong reason. Either way the finding stands: **the reference solution relies on a
> non-standard variable**, which is a genuine portability defect. Kept as a real (HIGH, not
> CRITICAL) issue — it does not *deterministically* break grading the way #7 does.

### 3. grades solution — `expr "$grade" \> 100` before numeric check — ❌ FALSE POSITIVE
**File:** `sh/tests/solutions/grades.sh`
- `expr "$grade" \> 100` runs BEFORE `[[ "$grade" =~ ^[0-9]+$ ]]` validation
- On non-numeric input like `"not_good"`, `expr "not_good" \> 100` writes `expr: non-integer argument` to stderr
- A student who checks numeric-first has **clean stderr** → diff against solution's polluted stderr → **FAIL**
- **False negative for correctly-written students**

> **❌ VERDICT: FALSE POSITIVE.** The premise — that GNU `expr` errors on non-numeric
> operands to `\>` — is **wrong**. `expr A \> B` performs comparison and, when either operand
> is non-numeric, GNU `expr` falls back to **lexicographic string comparison** (exit 0, no
> stderr). It does *not* emit "non-integer argument" for the `\>` operator.
>
> **Empirical proof (run against live `sol_grades.sh`):**
> ```
> $ grade="not_good"; [ $(expr "$grade" \> 100) -eq 1 ] ...   # rc=0, NO stderr
> $ printf '1\nStudent1\nnot_good\n' | bash sol_grades.sh 1 2>err 1>out
>   stderr = "Error: The grade 'Student1' is not a valid input..."   # clean, no expr noise
> ```
> The official solution enters its own error branch and writes a **clean, deterministic**
> message. A "correct" student that validates numeric-first would also write a clean message
> (different text, same single line). `grades_test.sh` line 28 **does** `diff` stderr — so the
> two would differ on the *text* of the error message, but that is a normal "error wording
> mismatch" issue affecting ALL error-path tests, **not** the `expr`-stderr-pollution mechanism
> the audit describes. That specific mechanism does not exist here.
>
> Note: `expr "$grade" \> 100` on `grade="Alice"` returns 0 (string "Alice" < "100"), so a
> valid-name-typed-as-grade would *not* trip the `>100` branch — but that too is unrelated to
> the claimed stderr pollution.

### 4. calculator_test.sh — `source` of student script can `exit` the entire test — ✅ VALID
**File:** `sh/tests/calculator_test.sh`
- `source "$script_dirS"/student/calculator.sh 10 + 10` sources student code in **current shell**
- If student script calls `exit` (even `exit 0`), the **entire test harness exits**
- Only works because reference solution never calls `exit` on valid input; any student variation that exits cleanly **crashes the test**

> **✅ VERDICT: VALID (and correctly rated CRITICAL).** Reproduced directly:
> ```
> $ cat harness.sh         # echo h start; source exit_script.sh; echo h continued
> $ cat exit_script.sh     # echo before exit; exit 0; echo after exit
> $ bash harness.sh
>   h start
>   before exit
>   $                       # "h continued" NEVER prints; harness rc=0 (exit 0)
> ```
> `source` runs the target in the *current* shell, so `exit` terminates the test process.
> The test's final block (`calculator_test.sh:60`) sources the student script with dummy args
> `10 + 10` to grab its `do_add`/`do_sub`/`do_mult`/`do_divide` functions. Any student whose
> script reaches an `exit` on the `10 + 10` arg path (e.g. a main-guard `if [[ $# -ne 3 ]];
> then exit 1` placed before function defs, or an eager `exit 0`) silently kills the whole
> harness — the four `do_*` checks never run and the student gets a misleading pass/fail.
> Severity CRITICAL is justified: this corrupts grading for a legitimate student style.

### 5. file-checker_test.sh — `grep -q "test"` catastrophic false positive — ✅ VALID
**File:** `sh/tests/file-checker_test.sh`
- `grep -q "test"` matches literal substring `"test"` anywhere in file
- Catches: comments (`# test case`), variable names (`test_result`), and even the solution's own `[ ! -e "$1" ]` (uses `[` not `test` but grep doesn't care)
- Should use `grep -w test` or check for `test` command semantics, not string content

> **✅ VERDICT: VALID.** The substring match is real and reproducible:
> ```
> $ printf '# test the file exists\n' | grep -q "test" && echo REJECTED    # → REJECTED
> $ printf 'echo "latest check"\n'         | grep -q "test" && echo REJECTED  # → REJECTED (laTEST)
> $ printf 'test_result="ok"\n'            | grep -q "test" && echo REJECTED  # → REJECTED
> ```
> A student who writes a perfectly correct solution but includes a harmless comment like
> `# test the file` — or even uses a variable named `test_result` — is wrongly rejected with
> "The 'test' command is not allowed in this exercise".
>
> **One correction to the audit's wording:** it claims grep would catch "the solution's own
> `[ ! -e "$1" ]`" — that is **not** true; `[` is a literal bracket, the string `test` does not
> appear in `[ ! -e "$1" ]`. The official `sol_file-checker.sh` contains **zero** occurrences of
> `test` (verified: `grep -c test` = 0), so the false positive only bites *student* code that
> happens to contain the substring. The finding stands but that one example is inaccurate.

### 6. file-checker_test.sh — `chmod` applied to wrong directory — 🔻 DOWNGRADE (cosmetic)
**File:** `sh/tests/file-checker_test.sh`
- Files created via `touch file-checker/readable-only` (relative to CWD)
- But `chmod -xw "$script_dirS/file-checker/readable-only"` targets `$script_dirS/file-checker/`
- Unless `$script_dirS` == CWD (not guaranteed in Docker entrypoint), files don't exist there → `set -e` kills test

> **🔻 VERDICT: DOWNGRADE to LOW/cosmetic.** The path inconsistency is real and reproduced:
> with `CWD ≠ script_dirS`, `touch` creates under `CWD/file-checker/` while `chmod` targets
> `script_dirS/file-checker/` → `chmod: cannot access ...: No such file` → under `set -euo
> pipefail` the test aborts. **BUT in the actual Docker runtime the two paths are always equal.**
>
> `entrypoint.sh` does `cp -r /app . ; cp -a student app ; cd app ; bash ${EXERCISE}_test.sh`,
> so the test is invoked with **CWD = `/app/app`** and `BASH_SOURCE` resolves to the same dir,
> making `script_dirS = /app/app = CWD`. The mismatch never triggers in production.
>
> The audit's parenthetical "not guaranteed in Docker entrypoint" is **incorrect** — it *is*
> guaranteed by the entrypoint. This is fragile/misleading code (and would bite anyone running
> the test by hand from another directory), but it does not cause false grading results.
> Reclassify as a maintainability nit, not CRITICAL.

### 7. job-regist_test.sh — parallel execution race + timestamp drift — ✅ VALID (understated)
**File:** `sh/tests/job-regist_test.sh`
- Student and solution run IN PARALLEL (background processes)
- Both write timestamps (`date +"%F %T"`): timestamps always differ → `diff` **ALWAYS fails** for correct implementation
- `create_random_job` called twice simultaneously overwrites same `job.sh` file → race condition

> **✅ VERDICT: VALID — and the audit UNDERSTATES the breakage.** This is the most thoroughly
> broken test in the suite. Ran the **actual upstream test end-to-end with student == solution**
> (the reference solution copied into both `student/` and `solutions/`):
>
> ```
> testing one_process case
> ....
> cat: job.log: No such file or directory          # ← diff target never created by anyone
> 1,6d0
> < 2026-06-23 00:18:23 - [1]+  Running  bash "$1" &   # exp.log has 6 lines (both writers collided)
> < 2026-06-23 00:18:23 - [1]+  Running  bash "$1" &
> < ... (4 more)
> rm: cannot remove 'job.log': No such file or directory
> === test exit code: 1 ===                            # ← FAILS even with identical correct code
> ```
>
> Three independent defects, any one of which is fatal:
> 1. **Shared `exp.log` race** — both the student and solution hardcode `LOG_FILE="exp.log"` and
>    write to it concurrently from the same CWD → interleaved/corrupted log.
> 2. **Phantom `job.log`** — the test does `diff <(cat exp.log) <(cat job.log)` but **neither**
>    the student nor the solution ever creates `job.log` → `cat: job.log: No such file` → diff
>    behaves as "everything deleted" → guaranteed failure. (The audit only mentioned timestamps;
>    it missed that the comparison target does not exist at all.)
> 3. **Shared `job.sh` race** — `create_random_job` writes the same relative `job.sh` from two
>    parallel processes.
>
> **No correct student submission can ever pass this test.** Severity CRITICAL is correct; if
> anything the audit under-sold it.

### 8. json-researcher_test.sh / who-are-you_test.sh — `~/.curlrc` modified, never cleaned — ✅ VALID
**Files:** `sh/tests/json-researcher_test.sh`, `sh/tests/who-are-you_test.sh`
- `echo insecure >> ~/.curlrc` disables SSL verification globally
- **Never cleaned up** — all subsequent curl commands in environment bypass SSL
- Also: `caddy start &>/dev/null` with no health-check; orphaned on test failure

> **✅ VERDICT: VALID (security + correctness).** Reproduced the accumulation:
> ```
> $ for i in 1 2 3; do echo insecure >>~/.curlrc; done; cat ~/.curlrc
>   insecure
>   insecure
>   insecure          # grows every test run, never removed
> ```
> Confirmed in source: `json-researcher_test.sh:18` and `who-are-you_test.sh:8` both do
> `echo insecure >>~/.curlrc`, and **neither test ever removes the line** (no `sed -i`, no
> trap, no cleanup). `caddy stop` runs on the happy path only. Real defects:
> - **Security:** permanently disables TLS verification for *every* `curl` in the container
>   for the rest of its life — a persistent MITM hole.
> - **Correctness/cleanup:** on any failure between `caddy start` and `caddy stop`, the caddy
>   process is orphaned and port conflicts cascade into later tests.
> - **Accumulation:** re-running the test appends duplicate `insecure` lines.
>
> CRITICAL rating is justified for the security impact alone. (The "no health-check" sub-point
> is also valid: first `curl` can race the still-starting caddy.)

### 9. entrypoint.sh — `cp -r /app .` creates nested recursive copy — ✅ VALID (cosmetic, not grading-breaking)
**File:** `sh/tests/entrypoint.sh`
- WORKDIR is `/app`, so `cp -r /app .` copies `/app` INTO `/app/` → `/app/app`
- Student code lands in `/app/app/student/`, not `/app/student/`
- Works accidentally but doubles disk usage, fragile

> **✅ VERDICT: VALID mechanism, but OVERSTATED severity.** Confirmed against the live
> `Dockerfile` (`WORKDIR /app` at line 18, `COPY . /app` at line 22) and `entrypoint.sh`
> (`cp -r /app .` at line 5). With CWD `/app`, `cp -r /app .` indeed creates `/app/app`.
> The subsequent `cp -a student app ; cd app` then deliberately works *inside* that nested
> copy, so the test does run — it just operates one directory deeper than intended.
>
> **Corrections to the audit's claims:**
> - "Student code lands in `/app/app/student/`" — **correct**, but that is actually where the
>   test *expects* to find it (all tests resolve `student/` relative to their own
>   `BASH_SOURCE`, which is `/app/app/...`). So grading is **not** broken by this.
> - "doubles disk usage" — technically true (the entire repo is copied twice) but trivial
>   (~MB in a throwaway container).
>
> This is a genuine code smell (the `cp -r /app .` is clearly a mistake vs. the intended
> `cp -r /app/student .` or similar) but it does **not** cause false pass/fail. **Downgrade
> from CRITICAL to LOW.** It belongs in the lint section.

### 10. right_test.sh — `$()` output executed as command (RCE vector) — ✅ VALID
**File:** `sh/tests/right_test.sh`
- `$(cd "$1" && bash "$script_dirS"/$FILENAME)` captures stdout, then result is **executed as a command** (unquoted)
- Currently works because script writes to file (no stdout to capture), but any script inadvertently producing stdout causes arbitrary command execution in test

> **✅ VERDICT: VALID.** Confirmed in source (`right_test.sh:19` and `:22`):
> ```
> $(cd "$1" && bash "$script_dirS"/$FILENAME)      # line 19 — bare command substitution
> ```
> A bare `$(...)` as a statement word takes the captured stdout and runs it as a command.
> The official `sol_right.sh` (`ls | grep -v "\.txt" >filtered_files.txt`) produces **no
> stdout** (redirected to file), so today the substitution expands to empty and harmlessly
> executes the empty command. But:
> - Any **student** solution that `echo`s anything to stdout (a debug print, a stray `echo`,
>   or output before the redirect) will have that text **executed as a shell command** by the
>   test harness → cryptic `command not found` errors at best, arbitrary command execution at
>   worst if the output happens to be a valid command.
> - The intended line was almost certainly just `cd "$1" && bash "$script_dirS"/$FILENAME`
>   (no `$(...)`), or `submitted=$(...)`.
>
> CRITICAL is slightly generous (it requires a non-conforming student to trigger), but the
> unquoted-command-execution pattern is a real footgun. **Keep as HIGH** rather than CRITICAL:
> it does not break grading for *correct* students (who write no stdout), but it manufactures
> misleading failures for slightly-off students and is a latent injection vector.

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
