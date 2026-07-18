---
name: aeon-evidence-ledger
description: Label verified versus assumed claims, choose checks that can fail, and report outcome, evidence, and risk before terminal comments or status moves.
---

# AEON Evidence Ledger

Use this skill before any terminal report, status move, scope frame, mint,
consult verdict, or completion claim.

## Two Ledgers

Every load-bearing claim is either:

- **verified:** backed by a command, output, diff, read-back, source, transcript,
  or observation you can cite.
- **assumed:** reasoned but not checked; name the basis and what would falsify
  it.

Do not average verified and assumed claims into one confident tone.

## Evidence That Can Fail

A check proves something only if it could have failed when the claim was false.

Examples:

- Store read-back can refute a mint.
- A criteria count can refute machine-readable acceptance.
- A production endpoint can refute a deploy claim.
- A grep can refute "unused".
- A diff can refute "no files outside scope changed".

Non-examples:

- Re-reading your own reasoning and finding it persuasive.
- A green command that does not exercise the changed behavior.
- A dev preview used as proof for a production surface.
- A worker report quoted as fact without a citable check.

## Report Order

1. Outcome.
2. Evidence.
3. Risk.

The first sentence must let the reader act correctly.

## Risk Section

Name:

- assumptions
- deferred work and where it is recorded
- strongest case that the report is wrong
- cheapest check that would catch the error

## Station-Specific Evidence

- DIRECTION: cited source, decision record, operating-layer conflict, or
  checkable acceptance evidence.
- SHAPE: node code, read-back diff, criteria count, surface walk, quote check,
  validation output.
- CODER: commands/output, commits, diffs, live or production-surface checks,
  child ticket statuses, SIMPLIFY disposition.
- SIMPLIFY: criteria/intent citation, grep/blame/thread evidence for removal
  claims, residual scar risk.

## Stop Conditions

Stop before reporting completion when:

- the central claim has no evidence
- a check cannot fail
- a subagent or worker claim is being treated as verified without review
- a risk is known but not stated
- the station quietly repaired a gap without naming it

