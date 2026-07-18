---
name: aeon-escalation
description: Raise, preserve, answer, and clear AEON decision questions without confusing escalation with dependencies or status updates.
---

# AEON Escalation

Use this skill when a station encounters a question it cannot lawfully answer
from its prompt, tethered node, project intent, and required skills.

## Core Rule

Escalation is a decision request. It is not a dependency edge.

- Dependency: "B waits for A."
- Escalation: "I need DIRECTION or the operator to decide X."

## When to Escalate

Escalate when the uncertainty would change:

- scope meaning or acceptance criteria
- station authority
- safety or data exposure
- cross-repo coherence
- operator policy
- deletion of a binding surface without recorded deferral
- deployment or host state outside the station's authority

Do not escalate because the work is large or difficult. Make station-local
implementation decisions inside the ratified scope.

## Route

| Origin | Route |
|---|---|
| CODER | unresolved question on the work-state thread, carried to DIRECTION |
| SHAPE | bounce on the source leg to DIRECTION |
| SIMPLIFY | suspected real defect to DIRECTION |
| DIRECTION | operator-only question to the operator |

## Required Shape of an Escalation

First line:

```text
QUESTION: <decision needed>; owner=<DIRECTION|operator>; blocks=<what waits>
```

Then:

- tethered node or leg id
- why station prompt + project intent + board do not answer it
- choices if they are real choices
- the smallest decision that unblocks work
- what work can continue meanwhile

## Status Handling

- Mark only the affected work blocked.
- Continue unblocked work.
- A leg is `blocked` only when this same station intends to resume on that leg
  after the answer.
- If the station has no further intention after raising the question, close the
  leg `done` and leave the question in the climbing surface.

## Comment Handling on RIM-Like Surfaces

- Leave genuine questions unresolved.
- Resolve progress and evidence comments.
- Do not bury a question inside a resolved status update.
- Do not create noise by leaving non-questions unresolved.

## Clearing an Escalation

When the answer returns:

1. Cite the answer.
2. State the resulting decision.
3. Clear or resolve the original question if the surface supports it.
4. Resume only the work actually unblocked.

## Stop Conditions

Stop and escalate immediately for:

- secrets or credentials in a diff
- public exposure or unsafe bind changes
- destructive operations without explicit authority
- operator-only foundational decisions
- ambiguous authority source

