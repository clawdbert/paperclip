---
name: aeon-work-state-surface
description: Operate the RIM-like work-state surface for node reads, writes, statuses, comments, criteria, dependencies, flushes, and read-back evidence.
---

# AEON Work-State Surface

Use this skill for RIM-like board work. SHAPE and CODER require the write form.
DIRECTION and SIMPLIFY use read-only variants only when their environment grants
them.

## Current RIM Surface

Use the existing `rim-ticketing`, `rim-methodology`, and `rim-communications`
skills for detailed mechanics. The as-consumed surface is:

- CLI reads: `rim tree`, `rim node`, `rim find`, `rim needs`, `rim errors`,
  `rim health`, `rim progress`.
- CLI reconciliation: `rim flush`.
- CLI skill inspection, when available: `rim skill list`, `rim skill targets`,
  `rim skill drift`.
- Node files are `.mdx` files with YAML frontmatter plus MDX body.
- Per-project stores live under `~/.rim/stores/<project>/store/*.mdx`.
- The prod board is multi-store; dependencies can cross mounted stores.

## Node Fields Agents Commonly Touch

Frontmatter fields in current RIM include:

- `code`, `id`, `kind`, `title`, `status`, `parent`
- `branch`, `started_commit`, `commit`
- `depends_on`
- `comments`
- `description`, `repo`, `publish`

Body components that matter to agents:

- `<Criterion id="...">...</Criterion>` for acceptance criteria.
- `<Question>...</Question>` for open questions.
- Mermaid diagram block for work nodes where the kind requires it.

## Status Discipline

- Scope node `done` is operator attestation. Agents never set it.
- CODER moves a completed scope node to `in review` with evidence.
- CODER may set its own child build/spike/execution tickets to `done`.
- SHAPE leaves new scopes at the pre-ratification state.
- A status move that performs a gate is forbidden.

Known current gotcha: the RIM status API may return 422 on gated transitions.
For authorized agent writes, edit node frontmatter directly, run `rim flush`,
and read back. Use the existing RIM skills for exact write procedure.

## Comments and Escalation

- Progress, completion, and evidence comments are resolved.
- A genuine question that needs another station or the operator stays
  unresolved so it can climb.
- Do not write inert `awaitsYou` fields. The marker is derived from unresolved
  conversation state.
- Always set an explicit author when writing a node comment; do not rely on API
  defaults.

## Dependency Discipline

- Work-state ticket to work-state ticket: `depends_on` in RIM.
- Out-of-DAG worker edge: leg-surface `blocked-by`.
- Never both.

## Write Procedure

1. Confirm this station has write authority for the node kind and status.
2. Edit only the sanctioned node file(s).
3. Preserve MDX parseability; escape bare syntax hazards.
4. Run `rim flush`.
5. Run `rim errors <PREFIX>` or the smallest relevant validation.
6. Read back the node with `rim node <CODE>` or the store file.
7. Report command/output or read-back evidence.

## Stop Conditions

Stop and report when:

- `RIM_URL` or equivalent board access is absent for a required write.
- The target node is unreachable.
- The write would exceed station authority.
- A status move would perform operator ratification or attestation.
- Criteria, questions, or comments cannot be represented in parseable form.

