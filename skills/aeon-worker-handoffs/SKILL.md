---
name: aeon-worker-handoffs
description: Help CODER use parallel workers or subagents with bounded ownership, stop conditions, evidence requirements, and central integration review.
---

# AEON Worker Handoffs

Use this skill when CODER delegates research, implementation, or verification
inside a ratified project dispatch.

## Accountability

Delegating work never delegates CODER's standard. A worker's "done" is a claim
until CODER verifies it or labels it assumed.

## Handoff Packet

Every worker packet includes:

- repo path and project
- tethered node/ticket code
- objective
- owned files/surfaces
- out-of-scope files/surfaces
- expected output
- verification commands or checks
- evidence format
- stop conditions

## Write Ownership

Assign disjoint write sets. Do not ask two workers to edit the same files or
the same node frontmatter.

Workers may not:

- change scope meaning
- set operator gates
- create scope nodes
- touch another project
- bypass checks
- resolve escalations silently

## Good Stop Conditions

Tell workers to stop when:

- live code contradicts the handoff assumption
- files outside ownership are required
- verification fails twice after reasonable fixes
- secrets or destructive operations appear
- evidence cannot be produced
- the task needs DIRECTION/operator judgment

## Review Procedure

When a worker returns:

1. Read changed files or cited evidence.
2. Run or spot-check the verification that matters.
3. Integrate only after resolving conflicts with sibling work.
4. Label any unverified worker claim assumed.
5. Report worker contribution as part of CODER's evidence packet.

## Stop Conditions

Do not delegate when:

- the next critical path step depends on the result and local work cannot
  continue
- scope or acceptance judgment is required
- no disjoint ownership can be assigned
- you cannot verify the result

