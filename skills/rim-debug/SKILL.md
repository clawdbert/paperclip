---
name: rim-debug
description: Debug rim by querying the service for parse/render errors and structural/acceptance violations, filterable by project, code, kind, status. Use for "what's broken / erroring / invalid" in rim, or to scope errors to one project.
---

# rim-debug — find what's wrong by calling the service

rim is self-instrumenting: the dev server (`http://localhost:5180`) reports every kind of
problem through one endpoint. **Don't eyeball files — query the service.**

## The endpoint

```
GET /api/errors[?project=…&code=…&kind=…&status=…]
```

Returns one row per node that has a problem:

```json
{ "code":"PRJ-15", "id":"…", "path":"myproject/…", "status":"in review", "kind":"build",
  "errors":     [ { "block":0, "line":12, "error":"…", "snippet":"…" } ],   // parse / render
  "violations": [ "0/3 acceptance criteria met — all must be met …" ] }      // structural / acceptance
```

A row appears if **either** list is non-empty.

### Filters (compose with AND)

| filter | meaning | example |
|---|---|---|
| `project` | code prefix (a project) | `?project=PRJ` · `?project=RIM` |
| `code` | one node by code or id | `?code=PRJ-15` |
| `kind` | only this kind | `?kind=build` |
| `status` | only this status | `?status=in%20review` |

```bash
curl -s 'http://localhost:5180/api/errors?project=PRJ'                # everything wrong in myproject
curl -s 'http://localhost:5180/api/errors?status=in%20review'         # partials sitting in review
curl -s 'http://localhost:5180/api/errors?project=RIM&kind=spike'     # rim spikes with problems
```

## The two columns

**`errors[]` — parse / render** (the node won't display right). Causes: malformed YAML
frontmatter (can empty the tree — see the resilience boundary), MDX parse errors (a raw
`<Tag>` in prose, an unclosed `{`), and expression reference errors (a binding used in one
block but `export`ed in another — the `SAMPLE` class). These also drive the needs-you
"Errors — need fixing" group.

**`violations[]` — structural / acceptance** (the node is ill-formed for its kind or its
lifecycle):

- **kind schema** — a `spike` with no `<Question>`, a `build` with no `<Criterion>`, a
  ticket with no ` ```mermaid ` diagram. Blocks advancing past triage.
- **acceptance** — `in review` or `done` with unmet acceptance criteria. Review means
  complete; this is an invalid state. Blocks the transition and is flagged on existing nodes.

The same `violations` are on every node in `GET /api/tree` (`node.violations`) and shown as
the `⚠` chip on the node header.

## Resolving each class

| symptom | fix |
|---|---|
| `frontmatter: …` | quote the offending YAML value (colons/quotes), or merge a stray second `---` block |
| `… is not defined` (render) | a sibling-block reference — keep the definition + use in one block, or self-contain it |
| `Expected component X to be defined` | suppressed (runtime/sibling-defined); a real typo is a genuine missing component |
| `kind 'spike' needs ≥1 question` etc. | add the field component (`<Question>` / `<Criterion>`) or a mermaid diagram |
| `N/M acceptance criteria met` | meet the criteria (a `test="…"` is the real way; a checkmark is soft), or **break the met criteria out into their own ticket** and leave the rest in coding |

## Notes

- A criterion is met by `test="…"` (real) or `done="true"` (soft — flagged, nudges to a test).
- To scope a sweep to one project, always pass `?project=` — rim and other projects share one
  store (another project's tickets live under `store/<project>/`, git-ignored; see the rim skill).
- The endpoint is read-only and cheap to poll while fixing.
