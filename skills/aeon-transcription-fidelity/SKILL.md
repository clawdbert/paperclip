---
name: aeon-transcription-fidelity
description: Help SHAPE prove a scope node faithfully transcribes DIRECTION's framing, with only board-readiness transformations and no silent repair.
---

# AEON Transcription Fidelity

Use this skill as SHAPE before reporting any mint or revision.

## Fidelity Definition

The node body equals DIRECTION's frame except for lawful board-readiness
transformations:

- MDX escaping
- machine-readable criteria structure
- required frontmatter
- mechanical formatting needed by the board

Everything else is content.

## Checks

Run these from source to node, not from memory:

1. **Body diff:** compare DIRECTION frame to read-back node body.
2. **Criteria count:** count `<Criterion id="...">` tags or deferral flag.
3. **Surface walk:** enumerate binding source surfaces and find each in
   criteria or DIRECTION-declared deferral.
4. **Quote check:** verify every quote labeled verbatim against its source.
5. **Scope count:** exactly one new node, or exactly named revisions.
6. **Status check:** node left for operator ratification.
7. **No extra products:** no child tickets, builds, spikes, executions,
   dependencies, or dispatches.

## Silent Repair Smells

Bounce rather than mint if:

- the node reads better than the frame
- criteria are shorter than named source surfaces
- you invented a deferral
- you completed or relabeled a quote
- you chose between two meanings
- you fixed DIRECTION's apparent mistake without asking

## Report Evidence

Report:

- node code(s)
- diff result
- criteria count or deferral
- validation result
- source surfaces checked
- quotes checked
- assumptions

## Stop Conditions

Stop and bounce when any fidelity check cannot be run or fails in a way SHAPE
cannot lawfully repair.

