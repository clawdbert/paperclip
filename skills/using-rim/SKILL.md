---
name: using-rim
description: The primary interface for driving rim from the shell — the `rim` CLI, which wraps the dev-server API and formats it so you read state at a glance instead of `curl … | python3`. The front door for inspecting and changing rim. Load whenever you need to look at or act on rim state (errors, the tree, a node, the glossary, flush, scaffold) outside the UI.
---

# Using rim — the `rim` CLI is the front door

rim's backend is the dev server's JSON API (`http://localhost:5180/api/*`), built for the app.
**Don't read that JSON by hand** (`curl … | python3 -c …` is the smell that you're missing the
tool). Drive rim with **`rim`** — it wraps the API and formats it for a human.

```sh
rim health                       # ✓ clean  /  3 errors · 34 issues
rim errors [CODE|PREFIX]         # errors + issues by severity; filter to a code/prefix
rim tree   [CODE]                # the forest, or one node's subtree, indented by kind
rim node   <CODE|id>             # a node: kind/status/parent, branch/commit, violations, body head
rim find   <text>                # nodes whose code or title match
rim term   <slug>                # a glossary term's definitions + their immutable refs
rim flush  [path]                # reconcile files → DB; prints how long + any parse errors
rim scaffold <file.mmd> [--parent id --prefix RIM --dry]   # a whole ticket tree from one diagram
```

- **Install:** `bin/rim` is a node script; symlink it onto PATH next to `synapse`/`stack`:
  `ln -sf "$PWD/bin/rim" ~/.local/bin/rim`. `RIM_URL=http://host:port rim …` retargets it.
- **Output is for reading** — colored, indented, counts up front. The exit code is non-zero on
  error (e.g. the dev server is down), so it composes in scripts too.

## When the CLI isn't enough — the raw API + the machine front door

The CLI covers the everyday reads/acts. For the full surface (and for *agents* bootstrapping
themselves), the JSON front door is still there:

```sh
curl -s http://localhost:5180/api/bootstrap    # what rim is + skills + the API + the queue
curl -s http://localhost:5180/api/agent/next   # pop the top task with its body + diff range
```

Useful endpoints the CLI doesn't wrap yet: `POST /api/status {path,status}` (move a ticket,
hard-gated), `POST /api/field/set` (attest a `<Criterion>`), `POST /api/comments/reply`,
`POST /api/agent/claim {code}`. See `rim`'s `/api/bootstrap` for the full list.

## Where to go deeper

- **`rim`** — how to drive rim *as methodology*: the node kinds, the status lifecycle + gates,
  authoring nodes, the single-approval-gate. Read it before scoping/ticketing/building.
- **`rim-debug`** — diagnosing what's wrong (the issue classes behind `rim errors`).
- **`rim-store`** — the store on disk: `store/` vs `published/`, hydrate/publish, the SQLite
  revision history.

One rule of thumb: **if you reach for `curl` + a JSON parser, reach for `rim` first.**
