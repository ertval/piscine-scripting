# Piscine Scripting — Research Handout

> Zone01 Athens / 01-edu Curriculum
> Compiled: June 2026

---

## 1. Key Repository: `01-edu/public`

**All tests and solutions live here:**
- https://github.com/01-edu/public

Base paths inside the repo:
```
sh/tests/                  # Test runners (*.sh)
sh/tests/solutions/        # Official solutions (*.sh)
sh/tests/Dockerfile        # Docker test environment
sh/tests/entrypoint.sh     # How tests are launched
subjects/0-shell/          # Shell subject READMEs
subjects/devops/           # Individual exercise instructions
```

**Raw file URL pattern:**
```
https://raw.githubusercontent.com/01-edu/public/master/<path-to-file>
```

---

## 2. How Tests Work

### Docker Environment
The tests run inside a Docker container based on **`debian:stable-slim`**.
Installed tools: `jq`, `curl`, `tree`, `apt-utils`, **`bc`**, `caddy`.

Source: `sh/tests/Dockerfile`
https://raw.githubusercontent.com/01-edu/public/master/sh/tests/Dockerfile

### Entry Point
The entrypoint copies your script into `/app/student/`, makes it executable, then runs the matching `*_test.sh`.

Source: `sh/tests/entrypoint.sh`
https://raw.githubusercontent.com/01-edu/public/master/sh/tests/entrypoint.sh

### Test Pattern
Most tests follow this pattern:

```bash
challenge() {
    submitted=$(bash "$script_dirS"/student/<exercise>.sh $@)
    expected=$(bash "$script_dirS"/solutions/<exercise>.sh $@)
    diff <(echo "$submitted") <(echo "$expected")
}
```

Your output must **exactly match** the solution's output (compared via `diff`).

---

## 3. Common Pitfalls & Restrictions

### ⚠️ The `test` Command Ban
Some exercises ban the `test` command. The check is:
```bash
if grep -q "test" "$script_dirS"/student/division.sh; then
    echo "Error: the test command cannot be used in the student script"
fi
```
This checks for the **literal string** `"test"` anywhere in your file — including comments!
The `[` command is technically synonymous with `test` but does NOT contain the string `"test"`, so `[ ... ]` passes this grep.
Avoid writing words like "test", "testing", "latest" in comments.

### ⚠️ The `echo` Ban
Some exercises ban `echo`:
```bash
if [ $(cat "$script_dirS"/"$FILENAME" | grep echo) ]; then
    echo "echo is not allowed in this exercise!"
    exit 1
fi
```
This grep also catches the word "echo" inside other words. Use `printf` or redirect output instead.

### ⚠️ Mandatory Constructs
Some exercises require specific constructs (e.g., `case`):
```bash
if [[ $(cat "$script_dirS"/student/calculator.sh | grep case | wc -l) -eq 0 ]]; then
    echo "Error: the use of case statement is mandatory"
    exit 1
fi
```

### ⚠️ Error Messages Must Match EXACTLY
The exercise description and the actual test sometimes disagree. Always match the **solution's output**, not the README. Example:
- README says: `"both arguments must be integers"`
- Solution uses: `"both arguments must be numeric"`

### ⚠️ No Explicit Exit Codes (Usually)
Most solutions do NOT use `exit 1` for errors. They use `if/elif/else/fi` and just `echo` the result. The test compares stdout, not exit codes.

### ⚠️ Line Endings
Must be **LF** (Unix), not CRLF (Windows). Always verify with `cat -A`.

### ⚠️ Floats vs Integers
The regex `^-?[0-9]*\.?[0-9]+$` accepts both integers and floats (used in `division.sh`, `comparator.sh`). Don't assume only integers.

### ⚠️ `bc` Division
The official solution does **NOT** use `scale=0`. Just `echo "$1 / $2" | bc`. With `bc`'s default scale of 0, this naturally truncates to integer for integer inputs while also handling floats.

---

## 4. Exercises with Tests + Solutions

### Shell Basics

| Exercise | Test | Solution | Notes |
|---|---|---|---|
| `hello` | [test](https://raw.githubusercontent.com/01-edu/public/master/sh/tests/introduction_test.sh) | [solution](https://raw.githubusercontent.com/01-edu/public/master/sh/tests/solutions/hello.sh) | |
| `plus` | [test](https://raw.githubusercontent.com/01-edu/public/master/sh/tests/plus_test.sh) | [solution](https://raw.githubusercontent.com/01-edu/public/master/sh/tests/solutions/plus.sh) | Uses `expr` |
| `division` | [test](https://raw.githubusercontent.com/01-edu/public/master/sh/tests/division_test.sh) | [solution](https://raw.githubusercontent.com/01-edu/public/master/sh/tests/solutions/division.sh) | Uses `bc`, no `scale=0`. Note: local `divide_test.sh` expects 'both arguments must be integers.' with periods, while remote solution expects 'both arguments must be numeric' without periods. |
| `easy-conditions` | [test](https://raw.githubusercontent.com/01-edu/public/master/sh/tests/easy-conditions_test.sh) | [solution](https://raw.githubusercontent.com/01-edu/public/master/sh/tests/solutions/easy-conditions.sh) | Reads env vars `$X` `$Y` |
| `hard-conditions` | [test](https://raw.githubusercontent.com/01-edu/public/master/sh/tests/hard-conditions_test.sh) | [solution](https://raw.githubusercontent.com/01-edu/public/master/sh/tests/solutions/hard-conditions.sh) | File permission checks |

### Calculator

| Exercise | Test | Solution | Notes |
|---|---|---|---|
| `calculator` | [test](https://raw.githubusercontent.com/01-edu/public/master/sh/tests/calculator_test.sh) | [solution](https://raw.githubusercontent.com/01-edu/public/master/sh/tests/solutions/calculator.sh) | Requires `case`, `do_add/sub/mult/divide` functions |

### File Operations

| Exercise | Test | Solution | Notes |
|---|---|---|---|
| `find-files` | [test](https://raw.githubusercontent.com/01-edu/public/master/sh/tests/find-files_test.sh) | [solution](https://raw.githubusercontent.com/01-edu/public/master/sh/tests/solutions/find-files.sh) | No `echo` allowed |
| `find-files-extension` | [test](https://raw.githubusercontent.com/01-edu/public/master/sh/tests/find-files-extension_test.sh) | [solution](https://raw.githubusercontent.com/01-edu/public/master/sh/tests/solutions/find-files-extension.sh) | Uses `find`, `iregex`, `cut` |
| `count-files` | [test](https://raw.githubusercontent.com/01-edu/public/master/sh/tests/count-files_test.sh) | [solution](https://raw.githubusercontent.com/01-edu/public/master/sh/tests/solutions/count-files.sh) | `find . -type d,f \| wc -l` |
| `largest` | [test](https://raw.githubusercontent.com/01-edu/public/master/sh/tests/largest_test.sh) | [solution](https://raw.githubusercontent.com/01-edu/public/master/sh/tests/solutions/largest.sh) | No `echo` allowed, `find`+`ls`+`sort`+`head`+`awk` |
| `custom-ls` | [test](https://raw.githubusercontent.com/01-edu/public/master/sh/tests/custom-ls_test.sh) | [solution](https://raw.githubusercontent.com/01-edu/public/master/sh/tests/solutions/custom-ls.sh) | Just an `alias` |
| `details` | [test](https://raw.githubusercontent.com/01-edu/public/master/sh/tests/details_test.sh) | [solution](https://raw.githubusercontent.com/01-edu/public/master/sh/tests/solutions/details.sh) | |
| `dir-info` | [test](https://raw.githubusercontent.com/01-edu/public/master/sh/tests/dir-info_test.sh) | [solution](https://raw.githubusercontent.com/01-edu/public/master/sh/tests/solutions/dir-info.sh) | |
| `file-checker` | [test](https://raw.githubusercontent.com/01-edu/public/master/sh/tests/file-checker_test.sh) | [solution](https://raw.githubusercontent.com/01-edu/public/master/sh/tests/solutions/file-checker.sh) | |
| `file-details` | [test](https://raw.githubusercontent.com/01-edu/public/master/sh/tests/file-details_test.sh) | [solution](https://raw.githubusercontent.com/01-edu/public/master/sh/tests/solutions/file-details.sh) | |
| `file-researcher` | [test](https://raw.githubusercontent.com/01-edu/public/master/sh/tests/file-researcher_test.sh) | [solution](https://raw.githubusercontent.com/01-edu/public/master/sh/tests/solutions/file-researcher.sh) | |
| `strange-files` | [test](https://raw.githubusercontent.com/01-edu/public/master/sh/tests/strange-files_test.sh) | — | |
| `file-struct` | [test](https://raw.githubusercontent.com/01-edu/public/master/sh/tests/file-struct_test.sh) | — | `.tar` archive |
| `better-cat` | [test](https://raw.githubusercontent.com/01-edu/public/master/sh/tests/better-cat_test.sh) | [solution](https://raw.githubusercontent.com/01-edu/public/master/sh/tests/solutions/better-cat.sh) | |

### I/O & Redirection

| Exercise | Test | Solution | Notes |
|---|---|---|---|
| `head-and-tail` | [test](https://raw.githubusercontent.com/01-edu/public/master/sh/tests/head-and-tail_test.sh) | [solution](https://raw.githubusercontent.com/01-edu/public/master/sh/tests/solutions/head-and-tail.sh) | No `echo` allowed, fetches from URL |
| `skip-lines` | [test](https://raw.githubusercontent.com/01-edu/public/master/sh/tests/skip-lines_test.sh) | [solution](https://raw.githubusercontent.com/01-edu/public/master/sh/tests/solutions/skip-lines.sh) | `sed -n 'n;p'` — prints every other line |
| `input-redirection` | [test](https://raw.githubusercontent.com/01-edu/public/master/sh/tests/input-redirection_test.sh) | [solution](https://raw.githubusercontent.com/01-edu/public/master/sh/tests/solutions/input-redirection.sh) | |
| `append-output` | [test](https://raw.githubusercontent.com/01-edu/public/master/sh/tests/append-output_test.sh) | [solution](https://raw.githubusercontent.com/01-edu/public/master/sh/tests/solutions/append-output.sh) | `cat ... \| grep ... >> results.txt` |

### Environment & Variables

| Exercise | Test | Solution | Notes |
|---|---|---|---|
| `env-format` | [test](https://raw.githubusercontent.com/01-edu/public/master/sh/tests/env-format_test.sh) | [solution](https://raw.githubusercontent.com/01-edu/public/master/sh/tests/solutions/env-format.sh) | `printenv PWD` + `printenv \| grep "H"` |
| `set-env-vars` | [test](https://raw.githubusercontent.com/01-edu/public/master/sh/tests/set-env-vars_test.sh) | [solution](https://raw.githubusercontent.com/01-edu/public/master/sh/tests/solutions/set-env-vars.sh) | `export` + `printenv \| grep "MY_"` |
| `set-internal-vars` | [test](https://raw.githubusercontent.com/01-edu/public/master/sh/tests/set-internal-vars_test.sh) | [solution](https://raw.githubusercontent.com/01-edu/public/master/sh/tests/solutions/set-internal-vars.sh) | |

### Comparison & Logic

| Exercise | Test | Solution | Notes |
|---|---|---|---|
| `comparator` | [test](https://raw.githubusercontent.com/01-edu/public/master/sh/tests/comparator_test.sh) | [solution](https://raw.githubusercontent.com/01-edu/public/master/sh/tests/solutions/comparator.sh) | Regex for floats, `-gt`/`-lt` |
| `greatest-of-all` | [test](https://raw.githubusercontent.com/01-edu/public/master/sh/tests/greatest-of-all_test.sh) | [solution](https://raw.githubusercontent.com/01-edu/public/master/sh/tests/solutions/greatest-of-all.sh) | |
| `grades` | [test](https://raw.githubusercontent.com/01-edu/public/master/sh/tests/grades_test.sh) | [solution](https://raw.githubusercontent.com/01-edu/public/master/sh/tests/solutions/grades.sh) | `read -p`, arrays, grade ranges |

### Permissions

| Exercise | Test | Solution | Notes |
|---|---|---|---|
| `easy-perm` | [test](https://raw.githubusercontent.com/01-edu/public/master/sh/tests/easy-perm_test.sh) | [solution](https://raw.githubusercontent.com/01-edu/public/master/sh/tests/solutions/easy-perm.sh) | |
| `hard-perm` | [test](https://raw.githubusercontent.com/01-edu/public/master/sh/tests/hard-perm_test.sh) | [solution](https://raw.githubusercontent.com/01-edu/public/master/sh/tests/solutions/hard-perm.sh) | |

### Job Control & Background

| Exercise | Test | Solution | Notes |
|---|---|---|---|
| `burial` | [test](https://raw.githubusercontent.com/01-edu/public/master/sh/tests/burial_test.sh) | [solution](https://raw.githubusercontent.com/01-edu/public/master/sh/tests/solutions/burial.sh) | `sleep &` + `jobs -l` + `awk` |
| `in-back-ground` | [test](https://raw.githubusercontent.com/01-edu/public/master/sh/tests/in-back-ground_test.sh) | [solution](https://raw.githubusercontent.com/01-edu/public/master/sh/tests/solutions/in-back-ground.sh) | |
| `job-regist` | [test](https://raw.githubusercontent.com/01-edu/public/master/sh/tests/job-regist_test.sh) | [solution](https://raw.githubusercontent.com/01-edu/public/master/sh/tests/solutions/job-regist.sh) | |

### Command Line & Aliases

| Exercise | Test | Solution | Notes |
|---|---|---|---|
| `auto-exec-bin` | [test](https://raw.githubusercontent.com/01-edu/public/master/sh/tests/auto-exec-bin_test.sh) | [solution](https://raw.githubusercontent.com/01-edu/public/master/sh/tests/solutions/auto-exec-bin.sh) | |
| `auto-jobs` | [test](https://raw.githubusercontent.com/01-edu/public/master/sh/tests/auto-jobs_test.sh) | [solution](https://raw.githubusercontent.com/01-edu/public/master/sh/tests/solutions/auto-jobs.sh) | `.tar` archive |
| `bin-status` | [test](https://raw.githubusercontent.com/01-edu/public/master/sh/tests/bin-status_test.sh) | [solution](https://raw.githubusercontent.com/01-edu/public/master/sh/tests/solutions/bin-status.sh) | Just `echo $?` |
| `master-the-ls` | [test](https://raw.githubusercontent.com/01-edu/public/master/sh/tests/master-the-ls_test.sh) | [solution](https://raw.githubusercontent.com/01-edu/public/master/sh/tests/solutions/master-the-ls.sh) | |
| `joker-num` | [test](https://raw.githubusercontent.com/01-edu/public/master/sh/tests/joker-num_test.sh) | [solution](https://raw.githubusercontent.com/01-edu/public/master/sh/tests/solutions/joker-num.sh) | |
| `remake` | [test](https://raw.githubusercontent.com/01-edu/public/master/sh/tests/remake_test.sh) | [solution](https://raw.githubusercontent.com/01-edu/public/master/sh/tests/solutions/remake.sh) | |
| `explain` | [test](https://raw.githubusercontent.com/01-edu/public/master/sh/tests/explain_test.sh) | [solution](https://raw.githubusercontent.com/01-edu/public/master/sh/tests/solutions/explain.sh) | |

### JSON & Research

| Exercise | Test | Solution | Notes |
|---|---|---|---|
| `json-researcher` | [test](https://raw.githubusercontent.com/01-edu/public/master/sh/tests/json-researcher_test.sh) | [solution](https://raw.githubusercontent.com/01-edu/public/master/sh/tests/solutions/json-researcher.sh) | Uses `jq` (installed in Docker) |
| `teacher` | [test](https://raw.githubusercontent.com/01-edu/public/master/sh/tests/teacher_test.sh) | [solution](https://raw.githubusercontent.com/01-edu/public/master/sh/tests/solutions/teacher.sh) | |

### Struct & Misc

| Exercise | Test | Solution | Notes |
|---|---|---|---|
| `change-struct` | [test](https://raw.githubusercontent.com/01-edu/public/master/sh/tests/change-struct_test.sh) | [solution](https://raw.githubusercontent.com/01-edu/public/master/sh/tests/solutions/change-struct.sh) | `.tar` archive |
| `check-user` | [test](https://raw.githubusercontent.com/01-edu/public/master/sh/tests/check-user_test.sh) | [solution](https://raw.githubusercontent.com/01-edu/public/master/sh/tests/solutions/check-user.sh) | |
| `who-are-you` | [test](https://raw.githubusercontent.com/01-edu/public/master/sh/tests/who-are-you_test.sh) | [solution](https://raw.githubusercontent.com/01-edu/public/master/sh/tests/solutions/who-are-you.sh) | |
| `hello-devops` | [test](https://raw.githubusercontent.com/01-edu/public/master/sh/tests/hello-devops_test.sh) | [solution](https://raw.githubusercontent.com/01-edu/public/master/sh/tests/solutions/hello-devops.sh) | |
| `array-selector` | [test](https://raw.githubusercontent.com/01-edu/public/master/sh/tests/array-selector_test.sh) | [solution](https://raw.githubusercontent.com/01-edu/public/master/sh/tests/solutions/array-selector.sh) | |
| `right` / `left` | [test](https://raw.githubusercontent.com/01-edu/public/master/sh/tests/right_test.sh) / [test](https://raw.githubusercontent.com/01-edu/public/master/sh/tests/left_test.sh) | [solution](https://raw.githubusercontent.com/01-edu/public/master/sh/tests/solutions/right.sh) / [solution](https://raw.githubusercontent.com/01-edu/public/master/sh/tests/solutions/left.sh) | |

### Command Line Camps (cl-camp1 through cl-camp8)

| Exercise | Test | Notes |
|---|---|---|
| `cl-camp1` | [test](https://raw.githubusercontent.com/01-edu/public/master/sh/tests/cl-camp1_test.sh) | File navigation |
| `cl-camp2` | [test](https://raw.githubusercontent.com/01-edu/public/master/sh/tests/cl-camp2_test.sh) | |
| `cl-camp3` | [test](https://raw.githubusercontent.com/01-edu/public/master/sh/tests/cl-camp3_test.sh) | |
| `cl-camp4` | [test](https://raw.githubusercontent.com/01-edu/public/master/sh/tests/cl-camp4_test.sh) | |
| `cl-camp5` | [test](https://raw.githubusercontent.com/01-edu/public/master/sh/tests/cl-camp5_test.sh) | |
| `cl-camp6` | [test](https://raw.githubusercontent.com/01-edu/public/master/sh/tests/cl-camp6_test.sh) | |
| `cl-camp7` | [test](https://raw.githubusercontent.com/01-edu/public/master/sh/tests/cl-camp7_test.sh) | |
| `cl-camp8` | [test](https://raw.githubusercontent.com/01-edu/public/master/sh/tests/cl-camp8_test.sh) | |

### Git

| Exercise | Test | Solution |
|---|---|---|
| `to-git-or-not-to-git` | [test](https://raw.githubusercontent.com/01-edu/public/master/sh/tests/to-git-or-not-to-git_test.sh) | [solution](https://raw.githubusercontent.com/01-edu/public/master/sh/tests/solutions/to-git-or-not-to-git.sh) |

---

## 5. Common Patterns in Official Solutions

### Input Validation (numeric)
```bash
! [[ $1 =~ ^-?[0-9]*\.?[0-9]+$ ]]
```
Accepts integers AND floats (e.g., `42`, `-7`, `3.14`).

### Input Validation (integer only)
```bash
! [[ $1 =~ ^-?[0-9]+$ ]]
```

### Argument Count Check
```bash
if [ $# -ne 2 ]; then
    echo "Error: ..."
fi
```

### Division by Zero Check (with bc for large numbers)
```bash
elif [ $(echo "$2 == 0" | bc) -eq 1 ]; then
    echo "Error: division by zero is not allowed"
fi
```

### Division with bc
```bash
result=$(echo "$1 / $2" | bc)
echo $result
```
No `scale=0` — bc's default scale handles truncation.

### Comparison Operators
```bash
[ "$X" -gt "$Y" ] && echo "true" || echo "false"
```

### Mandatory `case` Statement
```bash
case $2 in
    "+") echo $(do_add $1 $3) ;;
    "-") echo $(do_sub $1 $3) ;;
    ...
esac
```

### Find + Filter
```bash
find . -type f -exec ls -lha {} \; | sort -hrk5 | head -7 | awk '{printf("%5s | ", $5); print $NF}'
```

### Skip Every Other Line
```bash
ls -l | sed -n 'n;p'
```

### Background Jobs
```bash
sleep 2 &
jobs -l | awk '{print $1, $3, $4, $5, $6}'
```

---

## 6. Quick Checklist Before Submitting

- [ ] No literal string `"test"` anywhere in the file (comments included)
- [ ] No `echo` if the exercise bans it (grep catches it)
- [ ] Required constructs present (e.g., `case`) if exercise mandates them
- [ ] Error messages match the **solution**, not the README description
- [ ] LF line endings (verify with `cat -A` — should see `$` not `^M$`)
- [ ] Output matches solution exactly (no extra spaces, newlines, or formatting)
- [ ] Handles floats if regex uses `\.?` pattern
- [ ] Large integers handled via `bc`, not `$(( ))`
- [ ] No `scale=0` in bc division calls (use default)
- [ ] `if/elif/else/fi` structure without explicit `exit 1` (match solution pattern)
