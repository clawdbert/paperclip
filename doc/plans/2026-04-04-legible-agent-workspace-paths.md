# PRD: Human-Readable Agent Workspace Paths

**Date:** 2026-04-04  
**Branch:** legible-agent-workspaces  
**Status:** Ready for implementation

---

## Problem

Agent workspace directories and managed instruction bundle roots currently use raw UUIDs as path components:

```
~/.paperclip/instances/default/workspaces/3f2a1b4c-8d5e-4f6a-9b7c-0e1d2f3a4b5c/
~/.paperclip/instances/default/companies/company-1/agents/3f2a1b4c-.../instructions/
```

This makes it nearly impossible to navigate the filesystem manually, correlate logs to agents, or debug path-related issues. The fix replaces the raw-UUID fallback workspace path with a structured, human-readable slug.

---

## Goal State

After this change, the agent's default fallback workspace and managed instruction bundle root share a single base directory with this structure:

```
<base>/<ISSUE_PREFIX>/<name-stub>-<hash>/
```

Example:

```
/home/deploy/projects/paperclip-agents/ACME/founding-engineer-deba02/
/home/deploy/projects/paperclip-agents/ACME/founding-engineer-deba02/AGENTS.md
/home/deploy/projects/paperclip-agents/ACME/founding-engineer-deba02/HEARTBEAT.md
/home/deploy/projects/paperclip-agents/ACME/founding-engineer-deba02/TOOLS.md
/home/deploy/projects/paperclip-agents/ACME/founding-engineer-deba02/SOUL.md
```

- `ACME` — the company's `issuePrefix` value, uppercased (e.g. `"PAP"` → `"PAP"`)
- `founding-engineer` — `sanitizeFriendlyPathSegment(agent.name)`, first 50 chars
- `deba02` — first 6 hex chars of `sha1(agentId)` — stable across renames, collision-resistant

The base directory is operator-overridable via `PAPERCLIP_AGENT_WORKSPACES_DIR`. When unset it defaults to `<paperclipInstanceRoot>/agent-workspaces`.

---

## Scope

**8 files change. No DB migrations. No shared package type changes. No adapter changes.**

| File | Nature of change |
|---|---|
| `server/src/home-paths.ts` | Add 2 new functions, change 1 function signature |
| `server/src/services/agent-instructions.ts` | Add `issuePrefix` to `AgentLike`, delegate `resolveManagedInstructionsRoot` to `home-paths` |
| `server/src/services/heartbeat.ts` | Update 4 call sites of `resolveDefaultAgentWorkspaceDir` |
| `server/src/services/company-portability.ts` | Add `issuePrefix` to local `AgentLike` type |
| `server/src/config.ts` | Add `agentWorkspacesBaseDir` field + env-var read |
| `server/src/startup-banner.ts` | Print agent workspaces base dir at boot |
| `server/src/__tests__/agent-instructions-service.test.ts` | Add `issuePrefix` to test fixtures |
| `server/src/__tests__/agent-instructions-routes.test.ts` | Add `issuePrefix` to `makeAgent()` fixture |

---

## File-by-File Specification

### 1. `server/src/home-paths.ts`

**Current state** (lines 57–63):

```typescript
export function resolveDefaultAgentWorkspaceDir(agentId: string): string {
  const trimmed = agentId.trim();
  if (!PATH_SEGMENT_RE.test(trimmed)) {
    throw new Error(`Invalid agent id for workspace path '${agentId}'.`);
  }
  return path.resolve(resolvePaperclipInstanceRoot(), "workspaces", trimmed);
}
```

`sanitizeFriendlyPathSegment` already exists at line 65, unexported.

**Changes required:**

Add `resolveAgentWorkspacesBaseDir` after the existing `resolveDefaultStorageDir` export:

```typescript
export function resolveAgentWorkspacesBaseDir(): string {
  const override = process.env.PAPERCLIP_AGENT_WORKSPACES_DIR?.trim();
  if (override) return path.resolve(expandHomePrefix(override));
  return path.resolve(resolvePaperclipInstanceRoot(), "agent-workspaces");
}
```

Add `buildAgentWorkspaceSlug` alongside `sanitizeFriendlyPathSegment` (make it non-exported — internal helper):

```typescript
function buildAgentWorkspaceSlug(input: { agentName: string; agentId: string }): string {
  const nameStub = sanitizeFriendlyPathSegment(input.agentName, "_agent");
  const hash = crypto.createHash("sha1").update(input.agentId).digest("hex").slice(0, 6);
  return `${nameStub}-${hash}`;
}
```

Add `import crypto from "node:crypto";` at the top of the file.

Replace `resolveDefaultAgentWorkspaceDir` with the new signature:

```typescript
export function resolveDefaultAgentWorkspaceDir(input: {
  agentId: string;
  agentName: string;
  issuePrefix: string;
}): string {
  const base = resolveAgentWorkspacesBaseDir();
  const prefix = sanitizeFriendlyPathSegment(input.issuePrefix, "ORG").toUpperCase();
  const slug = buildAgentWorkspaceSlug({ agentName: input.agentName, agentId: input.agentId });
  return path.resolve(base, prefix, slug);
}
```

**No change to `resolveManagedProjectWorkspaceDir`** — it uses `companyId`/`projectId`, not agent identity.

---

### 2. `server/src/services/agent-instructions.ts`

**Current `AgentLike` type** (lines 30–35):

```typescript
type AgentLike = {
  id: string;
  companyId: string;
  name: string;
  adapterConfig: unknown;
};
```

**Change:** Add `issuePrefix`:

```typescript
type AgentLike = {
  id: string;
  companyId: string;
  name: string;
  issuePrefix: string;
  adapterConfig: unknown;
};
```

**Current `resolveManagedInstructionsRoot`** (lines 133–142):

```typescript
function resolveManagedInstructionsRoot(agent: AgentLike): string {
  return path.resolve(
    resolvePaperclipInstanceRoot(),
    "companies",
    agent.companyId,
    "agents",
    agent.id,
    "instructions",
  );
}
```

**Change:** Delegate to `resolveDefaultAgentWorkspaceDir`. Remove the import of `resolvePaperclipInstanceRoot` if no longer used elsewhere in this file (verify before removing). Add import of `resolveDefaultAgentWorkspaceDir`:

```typescript
function resolveManagedInstructionsRoot(agent: AgentLike): string {
  return resolveDefaultAgentWorkspaceDir({
    agentId: agent.id,
    agentName: agent.name,
    issuePrefix: agent.issuePrefix,
  });
}
```

Update the import line (currently line 4):

```typescript
import { resolveHomeAwarePath, resolveDefaultAgentWorkspaceDir } from "../home-paths.js";
```

Remove `resolvePaperclipInstanceRoot` from the import unless it's used elsewhere in the file (do a grep check — it's not used anywhere else in this file after this change).

**Important:** `resolveManagedInstructionsRoot` is called from multiple places inside `agent-instructions.ts` (lines 250–251, 277, 447–448, 522, 563, 695, 700). All those calls pass an `AgentLike`, so they automatically get the new path once `AgentLike` carries `issuePrefix`. No individual call site changes needed inside this file beyond the type and the one function body.

---

### 3. `server/src/services/heartbeat.ts`

There are **4 call sites** to update. All currently pass `agent.id` (a string). Each needs to be updated to pass the full object. The `agent` object at each call site already has `agent.id` and `agent.name`. What's missing is `issuePrefix` from the company.

**Context:** `heartbeat.ts` already queries the DB extensively. `agent.companyId` is always present at these call sites. You need `company.issuePrefix` to be in scope.

**Where to fetch it:**

Find the function that contains each call site and trace upward to where the company is or could be fetched. In most cases `agent.companyId` is available, so a targeted `db.query.companies.findFirst({ where: eq(companies.id, agent.companyId), columns: { issuePrefix: true } })` is sufficient. The `companies` table is already imported at the top of the file via `@paperclipai/db`.

**Call site details:**

| Line | Context | What to do |
|---|---|---|
| 551 | `resolveWorkspaceForRun` — checks whether previous CWD was agent home | Ensure `company` (with `issuePrefix`) is in scope; pass `{ agentId, agentName: agent.name, issuePrefix: company.issuePrefix }` |
| 1296 | Inside workspace resolution fallback | Same pattern |
| 1365 | `resolveWorkspaceForRun` no-project-workspace fallback | Same pattern |
| 2416 | Building `agentHome` for `AdapterExecutionContext` | Same pattern |

At each call site the updated call becomes:

```typescript
resolveDefaultAgentWorkspaceDir({
  agentId: agent.id,
  agentName: agent.name,
  issuePrefix: company.issuePrefix,
})
```

If a given call site is in a code path that already has the company record (from a join or prior DB query), reuse it. If not, add a targeted lookup — do not fetch the entire company row, just `{ id: true, issuePrefix: true }` to keep it minimal.

---

### 4. `server/src/services/company-portability.ts`

**Current local `AgentLike` type** (lines 471–475):

```typescript
type AgentLike = {
  id: string;
  name: string;
  adapterConfig: Record<string, unknown>;
};
```

**Change:** Add `issuePrefix`:

```typescript
type AgentLike = {
  id: string;
  name: string;
  issuePrefix: string;
  adapterConfig: Record<string, unknown>;
};
```

This type is local to `company-portability.ts` and independent of the one in `agent-instructions.ts`. Grep for where `AgentLike` objects are constructed in this file and ensure `issuePrefix` is populated from the company row. The company data is already present during import/export operations — populate it from there.

---

### 5. `server/src/config.ts`

**Current `Config` interface** (lines 44–76): Does not include agent workspaces base dir.

**Change:** Add one field to the `Config` interface:

```typescript
agentWorkspacesBaseDir: string;
```

Add the read in `loadConfig()`, following the same pattern as `storageLocalDiskBaseDir`:

```typescript
agentWorkspacesBaseDir: resolveAgentWorkspacesBaseDir(),
```

Add the import of `resolveAgentWorkspacesBaseDir` to the existing import from `"./home-paths.js"` (line 22–26).

**No** config file (`config.json`) schema change is required. `PAPERCLIP_AGENT_WORKSPACES_DIR` is env-var-only, following the precedent of `PAPERCLIP_HOME`.

---

### 6. `server/src/startup-banner.ts`

**Current `StartupBannerOptions` type** (lines 23–36): Does not include agent workspaces dir.

**Change:** Add one field:

```typescript
agentWorkspacesBaseDir: string;
```

In `printStartupBanner`, add a row after the `"Backup Dir"` row:

```typescript
row("Agent Workspaces", opts.agentWorkspacesBaseDir),
```

**At the call site** in `server/src/index.ts` (or wherever `printStartupBanner` is called), pass `config.agentWorkspacesBaseDir`.

---

### 7. `server/src/__tests__/agent-instructions-service.test.ts`

**Current `TestAgent` type** (lines 7–12) and `makeAgent` (lines 18–25):

```typescript
type TestAgent = {
  id: string;
  companyId: string;
  name: string;
  adapterConfig: Record<string, unknown>;
};

function makeAgent(adapterConfig: Record<string, unknown>): TestAgent {
  return {
    id: "agent-1",
    companyId: "company-1",
    name: "Agent 1",
    adapterConfig,
  };
}
```

**Change:** Add `issuePrefix` to both:

```typescript
type TestAgent = {
  id: string;
  companyId: string;
  name: string;
  issuePrefix: string;
  adapterConfig: Record<string, unknown>;
};

function makeAgent(adapterConfig: Record<string, unknown>): TestAgent {
  return {
    id: "agent-1",
    companyId: "company-1",
    name: "Agent 1",
    issuePrefix: "TEST",
    adapterConfig,
  };
}
```

The managed root path computed during tests will now be `<instanceRoot>/agent-workspaces/TEST/agent-1-<hash>/`. Tests that assert on specific managed root paths by string will need to be updated to use the new path. The `PAPERCLIP_HOME` env override pattern already in place (line 28) will keep test isolation intact.

**Also:** update the `afterEach` env cleanup to also reset `PAPERCLIP_AGENT_WORKSPACES_DIR` if any test sets it:

```typescript
const originalAgentWorkspacesDir = process.env.PAPERCLIP_AGENT_WORKSPACES_DIR;
// ...in afterEach:
if (originalAgentWorkspacesDir === undefined) delete process.env.PAPERCLIP_AGENT_WORKSPACES_DIR;
else process.env.PAPERCLIP_AGENT_WORKSPACES_DIR = originalAgentWorkspacesDir;
```

---

### 8. `server/src/__tests__/agent-instructions-routes.test.ts`

**Current `makeAgent()` fixture** (lines 75–91):

```typescript
function makeAgent() {
  return {
    id: "11111111-1111-4111-8111-111111111111",
    companyId: "company-1",
    name: "Agent",
    // ...other fields
  };
}
```

**Change:** Add `issuePrefix`:

```typescript
function makeAgent() {
  return {
    id: "11111111-1111-4111-8111-111111111111",
    companyId: "company-1",
    name: "Agent",
    issuePrefix: "TEST",
    // ...existing other fields unchanged
  };
}
```

---

## Invariants and Constraints

**Path stability:** The hash is derived from `agentId` (a UUID), not from `agentName`. This means renaming an agent does not change the hash suffix — only the name stub changes, which is acceptable. The slug is not a canonical identifier; the `agentId` is.

**Hash algorithm:** Use `crypto.createHash("sha1").update(agentId).digest("hex").slice(0, 6)`. SHA-1 gives better distribution than a raw UUID prefix slice. The `node:crypto` module is available in-process without adding a dependency.

**Sanitization:** `sanitizeFriendlyPathSegment` is already defined in `home-paths.ts` and handles all edge cases (null, empty, special characters). Do not duplicate it.

**issuePrefix default:** The `companies.issuePrefix` column has `default("PAP")` and is `notNull()`. There is no nil case to handle; the value is always a non-empty string.

**No migration for existing paths:** Existing agents with data at their old UUID-based path will need their `adapterConfig.instructionsRootPath` re-pointed if they were using managed bundles. This is an operator concern on upgrade, not in scope for this PR. The managed bundle recovery logic in `recoverManagedBundleState` already handles the case where the configured root doesn't match the managed root (it recovers from disk if files exist there) — so existing agents with an explicit `instructionsRootPath` continue working.

**`resolveManagedProjectWorkspaceDir` is unaffected.** It serves project workspaces (not agent workspaces) and uses `companyId`/`projectId` slugs, which are already human-readable.

---

## What Is NOT Changing

- `packages/adapter-utils/src/types.ts` — `AdapterExecutionContext.cwd` is a resolved string; construction is irrelevant
- `packages/db/src/schema/agents.ts` — no schema change; `issuePrefix` is on `companies`
- `packages/db/src/schema/companies.ts` — no schema change; `issuePrefix` already exists (line 12, default `"PAP"`)
- `server/src/services/execution-workspace-policy.ts` — unaffected
- `packages/shared/src/types/workspace-runtime.ts` — unaffected
- Any adapter `execute.ts` files — they receive the resolved workspace path as a string

---

## Acceptance Criteria

1. `resolveDefaultAgentWorkspaceDir({ agentId: "3f2a1b4c-...", agentName: "Founding Engineer", issuePrefix: "ACME" })` returns a path matching `<base>/ACME/founding-engineer-<6hexchars>/`.
2. The 6-char hash is stable: calling the function twice with the same `agentId` but a different `agentName` produces a different name stub but the **same** hash suffix.
3. `resolveManagedInstructionsRoot(agent)` returns the same path as `resolveDefaultAgentWorkspaceDir(agent)` — the instruction bundle lives inside the workspace dir.
4. `PAPERCLIP_AGENT_WORKSPACES_DIR=/custom/path` causes all workspace paths to be rooted at `/custom/path`.
5. The startup banner prints the resolved agent workspaces base directory.
6. All existing tests pass with `issuePrefix: "TEST"` added to fixtures.
7. TypeScript compiles without errors across all 8 changed files.
