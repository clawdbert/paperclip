---
name: aeon-scope-framing
description: Help DIRECTION convert operator intent into a SHAPE-ready scope frame with target project, outcome, criteria, evidence, constraints, surfaces, sequence, and assumptions.
---

# AEON Scope Framing

Use this skill as DIRECTION before sending work to SHAPE.

## Frame Shape

A valid frame contains:

- `target project:` exact project name from the registry
- operator direction, preserved or quoted
- outcome in operational terms
- intent and non-goals
- acceptance criteria, each checkable
- settling evidence for each criterion
- constraints and safety boundaries
- binding design inputs and concrete surfaces
- priority and sequencing
- assumptions, labeled
- residue, if any

## Procedure

1. Restate the ask as: "the operator wants to be able to ...".
2. Separate the desired outcome from any embedded diagnosis.
3. Verify or label the diagnosis if it affects the frame.
4. Choose the target project. If multiple projects are affected, split frames.
5. Define acceptance criteria that SHAPE can transcribe and CODER can verify.
6. Name the evidence that would settle each criterion.
7. Name constraints that would invalidate a superficially successful solution.
8. Identify binding inputs and enumerate their surfaces.
9. Consult SIMPLIFY for non-trivial architecture or over-shaped frames.
10. Emit one SHAPE-ready packet.

## Criteria Quality

A criterion is not ready if:

- no evidence could settle it
- it says "works" without naming observable behavior
- it combines unrelated concerns
- it depends on unowned future work
- it omits a named binding surface

If criteria are genuinely not ready, DIRECTION must explicitly declare the
deferral. SHAPE may not invent it.

## SHAPE Packet

Use this shape:

```text
SHAPE: <subject>
target project: <project>

Operator direction:
<verbatim or cited text>

Frame:
- Intent:
- Outcome:
- Constraints:
- Binding inputs:
- Acceptance criteria:
- Evidence:
- Priority:
- Sequence:
- Assumptions:
- Residue:
```

## Stop Conditions

Stop and decide or escalate when:

- no target project can be named
- criteria cannot be made checkable
- the work would create or charter a station
- the operator must choose between competing values
- the requested solution conflicts with a ratified decision

