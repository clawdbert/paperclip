---
name: aeon-promotion-and-doctrine
description: Help DIRECTION handle source-of-truth promotion, doctrine and prompt amendments, projection, and sanctioned drift absorption without hand-patching live surfaces.
---

# AEON Promotion And Doctrine

Use this skill as DIRECTION for source-of-truth promotion, station config,
prompt, projection, and operating-policy stewardship.

## Ground Rules

- Source artifacts are edited in their source of truth.
- Generated/live bundles are projection targets.
- Operator-authored UI edits are sanctioned input and must be absorbed or
  explicitly rejected, not clobbered.
- Skills are outside the current projector coverage; Paperclip assignment and
  the aeon-devops skills catalog own them.
- Applying generated artifacts requires operator go.

## Promotion Procedure

When a scope-proposed marker or comparable doctrine proposal is ready:

1. Verify the source scope has operator attestation.
2. Identify every proposed marker or pending doctrine block citing it.
3. Compare the proposed text against what the scope actually delivered.
4. If inconsistent, escalate rather than silently editing the claim.
5. Dispatch the exact source-of-truth edit to the proper station.
6. Require projection/check evidence before live apply.
7. Confirm generated outputs only after operator apply-go.

## Prompt/Skill Change Procedure

1. Identify current source owner.
2. Identify runtime projection target.
3. Read current prompt/skill assignment.
4. Decide whether the change is prompt material, skill material, or station
   authority material.
5. Keep tool/API procedures in skills unless the prompt needs a one-line trigger.
6. Frame acceptance criteria that prove:
   - source files changed
   - projection check passes or expected drift is named
   - no live bundle was hand-edited
   - skill assignment is specified even if not projector-managed

## Drift Absorption

If live bundle differs from source:

- determine whether it is operator-authored
- absorb it into source or ask operator to reject it
- never run apply over unknown live drift

## Stop Conditions

Stop and escalate when:

- the operator has not attested the originating scope
- a live edit may be sanctioned operator input
- the change affects station authority, model assignment, or gates
- skill provisioning is required but outside the executing station's authority
- the projector would overwrite live changes without absorption

