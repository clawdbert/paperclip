---
name: aeon-leg-surface
description: Operate the current Paperclip-like transport leg: read context, reply, create sanctioned handoff issues when authorized, and close done or blocked without treating transport as authority.
---

# AEON Leg Surface

Use this skill whenever an AEON station is woken by a Paperclip-like issue,
card, or leg.

This skill teaches transport mechanics. It does not decide authority. Run
`aeon-team-contracts` first.

## Current Paperclip Surface

Paperclip is the current leg surface. The as-consumed API facts are:

- API base is supplied by the environment or projection manifest.
- Mutating calls use bearer auth.
- Agent-scoped JWT calls may require `X-Paperclip-Run-Id` matching the signed
  run id.
- AEON currently uses routes under `/api`.

Common routes used by stations:

- Read the current leg context: `GET /api/issues/{id}/heartbeat-context`.
- Read an issue: `GET /api/issues/{id}`.
- Comment: `POST /api/issues/{id}/comments`.
- Update status or fields: `PATCH /api/issues/{id}`.
- Create an issue when this station is authorized to create work:
  `POST /api/companies/{companyId}/issues`.

Prefer the existing `paperclip` skill for exact auth, header, checkout, request
body, and multiline-comment mechanics. This skill defines AEON's use of that
surface.

## AEON Overrides

Do not use Paperclip-native approval or interaction workflows for AEON gates:

- no `request_confirmation`
- no `request_checkbox_confirmation`
- no `ask_user_questions`
- no `suggest_tasks`
- no `request_board_approval`

The operator gates in the work-state surface, not on the leg.

Do not use leg `in_review`. A leg closes `done` when the station has no further
intention.

## Procedure

1. Read the pre-assigned leg only. Do not sweep for work.
2. Classify the wake against the station authority contract.
3. Reply on the assigned leg or on the sanctioned handoff issue you are allowed
   to create.
4. Cite the work-state node code and URL when one exists so mirrors remain
   navigable.
5. Choose the final leg disposition:
   - `done` when the station has no further intention.
   - `blocked` only when the station intends to resume, with owner/action.
6. Include evidence and risk in the terminal comment.

## Authorized Creation

- DIRECTION may create SHAPE handoff issues and sanctioned stewardship child
  issues.
- Other stations create no new leg unless their prompt explicitly assigns that
  duty.
- SIMPLIFY normally reports inline on the consultation leg.

## Stop Conditions

Stop and report when:

- The leg is not assigned to this station.
- The leg lacks enough context to identify the tether or authority source.
- The requested mutation is outside this station's authority.
- Auth or run-id mechanics are missing and the existing `paperclip` skill cannot
  complete the call.

