# Rule of Two Detector (retired in v4.2.0)

**What it was:** a skill (`rule-of-two-detector`) plus a regex script (`git-learning-detector.sh`, kept in this folder) that scanned git history and scored five signal types to find documentation gaps.

**Why it was retired:** the signals were right, but fixed rules for detecting them weren't. The Rule of Two itself is still a core principle, and the signals now live in `learning-capture` as guidance the model applies with judgment.

---

## The five signals (still used)

1. **Repeated fix patterns**: the same issue fixed in different files or at different times.
2. **Defensive comments added**: `IMPORTANT`, `DON'T`, `NEVER` written into code.
3. **High-churn files**: files changed many times in the window (confusion zones).
4. **Terminology inconsistencies**: several names for one concept (`orgId`, `org_id`, `organizationId`).
5. **Learning words in commits**: TIL, turns out, figured out, gotcha.

---

## What happened in production

Run against a mature production repo for three months of history (2026-11-06):

- **207 "defensive comments added."** The examples were SSH client warnings and SVG diagram markup that had been committed to the repo, not warnings a developer wrote. The regex matched `WARNING` and `PROPOSED` wherever they appeared in added lines.
- **7 repeated-fix commits** and **0 learning words**: the commit history was ticket-prefixed and terse, so the learning-word signal had nothing to find.
- Cosmetic bugs: an escape code printed literally in the summary (`\033[1m214`), and the closing tip pointed at `context-tree-maintenance`, a skill retired in v4.0.0.

The script needed per-repo tuning (`WORKFLOW_PATTERNS` already had to be customized per ticket prefix), and the noise buried the few real signals. A model reading `git log` and choosing which diffs to open does the same job without the tuning, and can tell a committed SVG from a developer's warning.

## Connection to Anthropic's memory research

Anthropic's [Components of agent memory](https://www.anthropic.com/research/components-of-agent-memory) found the same pattern for memory: stronger models did better when told what memory is *for* and left to judge salience. A fixed "record only failures" rule reduced Opus 5's memory gain by 0.234. Same lesson here: keep the signals as purpose, drop the scoring rules.

---

## If you still want the script

`historical/git-learning-detector.sh` runs standalone (`bash historical/git-learning-detector.sh --since=3.months`). Use its output as raw material, not as a list of findings. Expect to filter generated files, vendored code, and committed tool output by hand.
