---
name: aeon-implementation-verification
description: Help CODER choose and report verification that proves the changed world, not just a command exit or worker claim.
---

# AEON Implementation Verification

Use this skill as CODER before setting child work `done`, moving a scope to
`in review`, reporting deploy success, or closing a dispatch leg.

## Principle

Evidence is the world's reply to the change.

## Choose the Smallest Failing-Capable Check

Pick the cheapest check that would fail if the claim were false:

- unit or integration test for logic
- typecheck/build for compile or bundle integration
- read-back for generated files
- diff against intended surfaces
- endpoint or UI observation for served behavior
- runtime status plus port plus health for deploy
- grep/blame/reference checks for deletion safety

## Wrong-Surface Smells

Do not use:

- dev server proof for a production-served UI
- command exit as deploy proof
- "browser verified" without naming the served URL/surface
- subagent report as verified evidence
- lint-only evidence for behavior
- generated file existence as proof of source truth

## Worker Claims

A worker or subagent return is a claim. Treat it as assumed until:

- you inspect the diff
- you run or cite a check
- you read back the changed surface
- or you explicitly label the claim assumed

## Completion Evidence Packet

Report:

- work-state node/ticket codes
- commits or diffs
- commands and meaningful output
- served/runtime observations if applicable
- SIMPLIFY advice disposition if consulted
- assumptions and deferrals
- cheapest remaining check

## Stop Conditions

Do not move to `in review` when:

- the central behavior was not checked
- evidence is from the wrong surface
- a binding source surface is unowned
- deleted capability lacks deferral
- a worker claim is load-bearing and unverified
- safety or host-state risk remains unresolved

