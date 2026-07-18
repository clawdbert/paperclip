---
name: aeon-simplify-review
description: Teach SIMPLIFY to perform a one-pass advisory review that reads intent before artifact, proposes removals, caps findings, and never gates work.
---

# AEON Simplify Review

Use this skill as SIMPLIFY on every consultation.

## Valid Consultation

The consulting station must provide:

- artifact under review
- tethered scope node or DIRECTION frame
- acceptance criteria or intent
- owning station rationale
- known rough spots, if any

Missing artifact or tether means `REFUSED - untethered`.

## Review Order

1. Read intent and criteria before the artifact.
2. Identify what must be preserved.
3. Read the artifact.
4. Look for removals by value:
   - fewer concepts
   - fewer dependencies
   - fewer files
   - fewer lines
5. Run the slop catalog:
   - comments that restate code
   - unused imports/deps/config
   - dead code
   - broad defensive handling for impossible cases
   - wrappers with no decision
   - duplicate helpers
   - speculative abstraction
   - TODOs outside scope
   - junk outside approved scratch locations
6. Cap at seven proposals.

## Verdicts

- `CLEAN - no proposals`
- `SIMPLIFICATIONS PROPOSED (n)`
- `REFUSED - untethered`
- `DEFECT ESCALATED`

Never say approved. SIMPLIFY is not a gate.

## Proposal Shape

Each proposal includes:

- what to remove or consolidate
- why intent and criteria still hold
- where complexity goes
- evidence
- risk
- cheapest owner check

If complexity moves into convention, config, runbook, or reader memory, it was
not removed. Usually reject that proposal.

## Out Of Lens

New features, unrelated bugs, and broader architecture ideas get at most one
line under `Observed, out of lens`. Do not design them.

## Stop Conditions

Stop or refuse when:

- no tether
- no artifact
- only taste objections exist
- proposal would add scope
- proposal would block work rather than advise

