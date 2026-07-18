---
name: aeon-scope-minting
description: Teach SHAPE the exact scope-node mint/revision procedure: target board, node fields, criteria, MDX safety, commit, flush, validation, read-back, report, and terminal leg state.
---

# AEON Scope Minting

Use this skill as SHAPE for new scope nodes or DIRECTION-authorized revisions.

## Preconditions

- Input is from DIRECTION.
- Input names a target project.
- The target project has a registered work-state store.
- DIRECTION supplies a frame with intent, outcome, criteria or explicit
  deferral, constraints, and binding inputs.

## Node Requirements

For a new scope, create one `.mdx` node with frontmatter including:

- `code`
- `id`
- `kind: scope`
- `title`
- `parent`
- `status: triage` or the current pre-ratification status used by the board

Body requirements:

- DIRECTION framing transcribed faithfully.
- Mermaid diagram if required by local RIM schema.
- Acceptance criteria as `<Criterion id="...">...</Criterion>`, one per
  DIRECTION criterion.
- No bare MDX syntax hazards left unescaped.

Do not create build, spike, execution, or dependency nodes.

## Procedure

1. Verify DIRECTION authority and target project.
2. Classify new mint vs revision. Existing node code(s) mean revision.
3. Draft the node with board-readiness changes only.
4. Preserve named surfaces and quotes.
5. Commit the store change.
6. Run `rim flush`.
7. Run `rim errors <PREFIX>` or the local validation required by
   `rim-ticketing`.
8. Read back the stored node.
9. Count `<Criterion id="...">` tags or verify DIRECTION-declared deferral.
10. Comment on the source leg with node code(s), evidence, assumptions, and
    residue.
11. Close the leg `done` when there is no further intention.

## Revision Rule

If DIRECTION names existing node codes, revise exactly those nodes. Do not mint
fresh. If DIRECTION does not name existing node codes, mint one new scope. Do
not infer revision from resemblance.

## Stop Conditions

Bounce to DIRECTION when:

- target project is missing or unrecognized
- criteria are absent without DIRECTION-declared deferral
- a binding source is unreachable
- a quote cannot be verified
- preserving fidelity requires a content decision
- SIMPLIFY's feedback would require changing content

Refuse when the input is not from DIRECTION or asks SHAPE to decompose,
implement, dispatch, or move status beyond pre-ratification.

