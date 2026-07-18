---
name: aeon-direction-coherence
description: Help DIRECTION use the operating layer, decision records, registries, project intent, and prior rulings to maintain cross-repo and station coherence.
---

# AEON Direction Coherence

Use this skill only as DIRECTION, or as a reviewer checking DIRECTION's proposed
coherence work.

This is the home for the operating-layer burden. Other stations should use the
distilled team contracts and escalate global-policy surprises to DIRECTION.

## Inputs

Use the available sources in this order:

1. Operator instruction in the current thread or leg.
2. Accepted decision records in `docs/decisions/`.
3. Current task-flow decision: `notes/task-flow-resolution-proposal.md`.
4. Operating layer as policy context.
5. Project registry and per-project intent anchors.
6. Live station contracts and projection manifest.
7. Current board/thread evidence.

## Coherence Pass

For every actionable direction, answer:

- Which project owns the work?
- Which source of truth owns the changed artifact?
- Which station has authority to produce it?
- Which repos or generated surfaces must be updated after the keystone?
- Which existing decisions constrain the solution?
- Is any operating-layer text stale against live station contracts or relay
  behavior?
- What must be explicitly out of scope?

## Keystone-First Sequencing

Name the claim or artifact that everything else depends on. Dispatch it first.

Common keystones:

- team contract before station prompts
- skills before prompts that require them
- source-of-truth edit before generated projection
- control-plane change before sibling repo adoption
- policy decision before implementation

## Fan-Out Rule

If one operator decision touches multiple repos:

1. Frame the control-plane source-of-truth change first.
2. Frame sibling repo changes separately.
3. Sequence rather than merge cross-project work into one CODER wake.
4. Keep residue visible.

## Operating-Layer Drift

If the operating layer conflicts with observed live behavior:

- do not silently choose a version
- name the conflict
- decide within DIRECTION authority only if the answer is already ruled
- otherwise escalate to the operator or frame a policy amendment

## Outputs

A DIRECTION coherence output must include:

- decision or framed scope
- target project(s)
- source-of-truth owner
- blast radius
- sequence
- acceptance evidence
- assumptions and residue

## Stop Conditions

Stop or escalate when:

- the requested change amends station authority or operator gates
- no source of truth can be identified
- sibling repo impact cannot be assessed
- live runtime contradicts policy and no ruling resolves precedence
- the operator must make a value tradeoff

