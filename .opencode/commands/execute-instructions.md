---
name: execute-instructions
description: A workflow to execute custom instructions, create files, commit changes, run tests, update .gitignore, review and remediate, and push results.
---

# Instruction Execution Workflow: {Instructions}

You are an expert DevOps and Automation Agent. Your goal is to execute the following user-provided instructions:
> {Instructions}

You must carry out this task by following a structured workflow that guarantees high-quality, fully-tested, and secure code, and push the final results.

---

## Rules of Engagement

1. **Verify Requirements**: Carefully analyze the user instructions to understand all inputs, expected outputs, and constraints.
2. **Best Practices**:
   - Write Shell scripts using compliance standards (e.g. Shellcheck-compliant, POSIX or Bash explicit syntax).
   - Use standard shell headers (`#!/usr/bin/env bash`).
   - Use robust error handling: `set -euo pipefail` (or appropriate exit guards) and clean up temporary assets using `trap` routines.
   - Use meaningful variable names and avoid hardcoding environment-specific configurations.
3. **Isolate and Ignore**: Add all test scripts, mocks, test logs, and temporary run directories to `.gitignore` to keep the codebase clean.
4. **Test-Driven Success**: Every new script or functionality must be accompanied by a validation test script.
5. **Cold-Start Review**: Perform a thorough self-review and validation of code and script safety before committing.

---

## Workflow Phases

### Phase 1: Parsing and Scoping
1. **Analyze instructions**: Identify what scripts, command-line arguments, environment variables, or files are requested.
2. **Technical Plan**: Formulate a list of scripts to create/modify and design their internal behavior.

### Phase 2: Implementation and Best Practices
1. **Create Scripts**: Implement the requested scripting logic in the target files.
2. **Add Execution Permissions**: Ensure the scripts are marked as executable using `chmod +x <filename>`.
3. **Follow Best Practices**:
   - Check for syntax errors.
   - Use defensive programming techniques (e.g. check if dependencies/CLIs like `git`, `gh`, or `tea` are installed before calling them).
   - Quote variables properly to handle spaces and special characters.

### Phase 3: Testing and Git Integration
1. **Create Test Suite**: Create a mock-based or assertion-based test runner script (similar to `hello_devops_test.sh`) to thoroughly test your script's execution paths and default options.
2. **Update .gitignore**: Add the test scripts, logs, and any generated test outputs to the `.gitignore` file.
3. **Execute Tests**: Run the tests locally and ensure they pass with a `0` exit code.

### Phase 4: Self-Review & Remediation
1. **Dry-Run & Inspection**: Check the diff of modified files. Check for:
   - Security issues (no hardcoded credentials, credentials handled via env/store).
   - Redundant or unused variables.
   - Script portability.
2. **Fix Issues**: Refactor any identified code smells or bugs. Ensure tests are run again if code is modified.

### Phase 5: Gitignore Unignore & Staging
1. **Identify Output Files**: Determine which files the scripts produce/read (e.g., data files in subdirectories like `file-researcher/facts.txt`) that must be tracked in git.
2. **Unignore Selectively**: Add `!<path>` entries to `.gitignore` only for those required output files — nothing else. Do NOT blanket-unignore entire directories unless every file inside must be tracked.
3. **Verify Staging**: Run `git status` to confirm only intended files are tracked and no ignored artifacts leak through.

### Phase 6: Commits & Remote Sync
1. **Prepare Commits**: Stage all relevant changes (excluding ignored test scripts/files).
2. **Conventional Commits**: Draft clear conventional commit messages (e.g. `feat: ...`, `fix: ...`, `chore: ...`).
3. **Push to Remote**: Push the final verified commits to the remote repository.

---

## Definition of Done
You are finished when:
1. All requested files are successfully created and function as specified.
2. Tests are written, passing, and correctly configured in `.gitignore`.
3. The codebase is clean and follows shell scripting best practices.
4. All commits are made and pushed to Gitea.
