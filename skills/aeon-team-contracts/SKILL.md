---
name: aeon-team-contracts
description: Load the AEON station authority model, reporting lines, lifecycle objects, terminal states, status/dependency contracts, and escalation boundaries before classifying a wake.
---

# AEON Team Contracts

Use this skill at the start of every AEON station wake.

## What This Skill Establishes

- Authority source: who can instruct this station.
- Transport source: what merely woke this station.
- Output contract: what artifact this station owes.
- Terminal states: which statuses this station may set.
- Escalation route: where unanswered decisions climb.

## Station Authority

| Station | Instructions from | Reports to | Escalates to |
|---|---|---|---|
| DIRECTION | operator only | operator | operator |
| SHAPE | DIRECTION only | DIRECTION | DIRECTION |
| CODER | tethered work-state node only | work-state node and current leg | DIRECTION |
| SIMPLIFY | consultation request only | consulting station | DIRECTION for real defects only |

Transport is not authority. A relay event, issue, card, mention, or heartbeat
can wake a station; it does not add instructions outside the station's authority
source.

## Lifecycle Objects

- **Scope node:** work-state lifecycle and acceptance object of record.
- **CODER child ticket:** execution unit cut by OUGHT; CODER may self-attest
  only its own child work.
- **Transport leg:** receipt that wakes one station and records its reply.
- **Consult report:** SIMPLIFY's advisory output.

## Status Contract

- The scope node owns the real lifecycle.
- A transport leg is a receipt, never a review queue.
- A finished leg closes `done` when the assigned station has no further
  intention, even if the scope node is still `in review`.
- A leg is `blocked` only when the station intends to resume and can name the
  unblock owner and action.
- CODER never sets a scope node `done`; that is operator attestation.

## Dependency Contract

- Both endpoints are work-state tickets: the edge lives in the work-state DAG.
- An endpoint is deliberately outside the work-state surface: the edge may live
  in leg-surface `blocked-by`.
- Never both.
- Never prose only.

## Escalation Boundary

A dependency edge sequences work. An escalation asks for a decision.

Escalate when a question would change scope, authority, safety, acceptance,
cross-repo coherence, or operator policy. Do not escalate when the question can
be answered from the tethered node, project intent, station prompt, or required
skills.

## Wake Classification Checklist

Before acting, state:

1. Who is instructing me?
2. What surface woke me?
3. What tether authorizes this work?
4. What artifact do I owe?
5. Which terminal states are lawful for this station?
6. If blocked, who owns the unblock action?

If any answer is missing, stop and report the missing contract rather than
improvising.

