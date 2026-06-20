# Agent Instructions: piscine-scripting

Guidelines, rules, and configuration tracking for AI agents operating in this repository.

---

## 1. RTK - Rust Token Killer

All shell commands MUST be prefixed with the `rtk` command to optimize context size and minimize token consumption:
- **Rule**: Use `rtk <command>` instead of raw shell commands.
- **Examples**: 
  - `rtk git status`
  - `rtk bash hello_devops_test.sh`
  - `rtk ls -la`
- **Savings**: Run `rtk gain` to view cumulative token savings in this session.

---

## 2. Karpathy Guidelines

Follow the 4 principles of software engineering to minimize coding errors (see details in the local [karpathy-guidelines](file:///home/ertval/code/zone-modules/piscine-scripting/.agents/skills/karpathy-guidelines/SKILL.md) skill):
1. **Think Before Coding**: Explicitly state assumptions, surface tradeoffs, and clarify ambiguity.
2. **Simplicity First**: Write the minimum amount of code to solve the problem. Nothing speculative.
3. **Surgical Changes**: Touch only what you must. Match existing style.
4. **Goal-Driven Execution**: Define clear success criteria and verify changes systematically.

---

## 3. Gitea CLI (tea)

Use the Gitea CLI (`tea`) to manage issues, pull requests, releases, and repository configuration under the `zone01` login.

---

## 4. Caveman Mode

Always use the `caveman` skill to reduce context size.

## 5. Git push last changes
Alwasy push after you made changes
