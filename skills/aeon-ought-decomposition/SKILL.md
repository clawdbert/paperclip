---
name: aeon-ought-decomposition
description: Help CODER decompose ratified work into OUGHT-aligned child tickets with coverage, dependencies, spikes for unknowns, and one-agent-one-diff execution units.
---

# AEON OUGHT Decomposition

Use this skill as CODER when a ratified scope is more than one obvious diff.
It complements the existing `rim-methodology` and `rim-ticketing` skills.

## Inputs

- Ratified scope node.
- Acceptance criteria.
- Binding design inputs and surfaces.
- Constraints and non-goals.
- Project intent anchor.

## Decomposition Rules

- One agent, one diff.
- Unknowns that shape the fork become spikes.
- Build tickets own concrete deliverables.
- Every deliverable and binding surface maps to exactly one child ticket or an
  explicit deferral on the scope thread.
- Dependencies between work-state tickets live in the work-state DAG.
- Do not cut cross-project child work inside one project dispatch.

## Ticket Kinds

Use the current RIM kind expectations:

- `build`: one implementation diff; must have criteria.
- `spike`: one unknown; must have questions.
- `execution`: coordination/DAG holder when the local methodology requires it.

Include the mermaid/body structure required by the current RIM schema and
validate after minting.

## Coverage Ledger

Create a coverage ledger before minting:

| Source item | Surface/deliverable | Child ticket or deferral |
|---|---|---|

Walk from source inputs to ticket list. Do not walk from the ticket list back to
the inputs; that misses unowned surfaces.

## Dependency Home

- Both endpoints are work-state tickets: `depends_on` in RIM.
- One endpoint deliberately outside RIM: leg-surface blocked-by.
- Never both.

## Stop Conditions

Escalate or spike when:

- a surface cannot be mapped
- an unknown changes the implementation fork
- work crosses project boundaries
- a deferral would change acceptance meaning
- a child ticket cannot be checked independently

