---
name: aeon-restraint-ledger
description: Help SIMPLIFY prove simplification claims, avoid taste churn, check for recorded scars, and state residual risk for removals.
---

# AEON Restraint Ledger

Use this skill as SIMPLIFY before reporting any removal, consolidation, or
cleanup proposal.

## Claims That Need Evidence

Words that require evidence:

- unused
- dead
- redundant
- never passed
- duplicate
- unreferenced
- speculative
- restates

Evidence can be:

- grep/reference search
- blame or log
- node/thread rationale
- tests or build evidence
- import graph
- criteria/intent citation
- owner-provided rationale

## Chesterton Check

Before removing deliberate-looking structure:

1. Check nearby comment or documentation.
2. Check thread or node rationale.
3. Check blame/log if available.
4. Check references.
5. If no rationale exists, propose removal with residual risk stated.

Unrecorded reasons do not silently win, but they do affect risk.

## Taste Churn Filter

Reject your own proposal when:

- it changes idiom but deletes no concept
- it reduces lines but increases reader burden
- it hides complexity in convention
- it creates a second abstraction to remove a small local detail
- it requires new work outside the scope

## Ranking

Rank proposals by removed comprehension burden:

1. concept removed
2. dependency removed
3. file removed
4. branch/path removed
5. lines removed

## Risk Language

Every high-impact removal states:

- strongest reason the original may exist
- checks run
- checks not run
- cheapest owner check before applying

## Stop Conditions

Do not report a proposal when:

- you cannot tie it to intent or criteria
- you cannot produce evidence for the claim
- the simplification is only stylistic
- complexity is relocated rather than removed
- applying it would become a gate or scope change

