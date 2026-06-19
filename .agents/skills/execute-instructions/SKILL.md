---
name: execute-instructions
description: Structured 5-phase workflow for executing custom instructions. Parse, implement, test, review, commit, push. Shell scripting best practices, test-driven, Gitea push.
triggers:
  - "execute these instructions"
  - "run this workflow"
  - "implement and push"
  - "create script and test"
  - "devops task"
  - "automation task"
allowed-tools:
  - Read
  - Write
  - Edit
  - Glob
  - Grep
  - Bash
  - Task
effort: high
tags: [workflow, devops, automation, shell-script, testing, git]
---

# Instruction Execution Workflow

Execute user-provided instructions through a structured 5-phase workflow: parse → implement → test → review → ship.

Load this skill when the task involves implementing instructions, creating shell scripts, writing tests, and pushing to Git. Do NOT load for simple edits, questions, or research-only tasks.

## Rules of Engagement

1. **Verify Requirements**: Analyze instructions fully — inputs, outputs, constraints.
2. **Best Practices**:
   - Shell scripts: `#!/usr/bin/env bash`, `set -euo pipefail`, `trap` for cleanup.
   - Check dependencies (`git`, `gh`, `tea`) before calling them.
   - Quote variables, avoid hardcoded env config.
3. **Isolate and Ignore**: Add test scripts, mocks, logs, temp dirs to `.gitignore`.
4. **Test-Driven Success**: Every script needs a validation test.
5. **Cold-Start Review**: Self-review code and script safety before committing.

## Workflow Phases

### Phase 1: Parsing and Scoping
- Analyze instructions → identify scripts, args, env vars, files requested.
- Formulate technical plan: list files to create/modify, their internal behavior.

### Phase 2: Implementation
- Implement scripts in target files.
- `chmod +x <filename>` for executables.
- Syntax check, defensive programming, proper quoting.

### Phase 3: Testing and Git Integration
- Create test suite (mock-based or assertion-based runner).
- Update `.gitignore` with test artifacts.
- Run tests locally — must exit 0.

### Phase 4: Self-Review & Remediation
- Check diff for: security issues, redundant vars, portability.
- Refactor code smells, re-run tests if modified.

### Phase 5: Commits & Remote Sync
- Stage only relevant changes (exclude ignored files).
- Conventional commits: `feat:`, `fix:`, `chore:`.
- Push to remote.

## Definition of Done

1. All requested files created and functional.
2. Tests written, passing, in `.gitignore`.
3. Codebase clean, shell best practices followed.
4. Commits made and pushed to Gitea.
