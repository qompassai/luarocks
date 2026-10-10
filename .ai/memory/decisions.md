# Architectural Decisions

## License normalization (2026-09-28)

**Decision**: Apache-2.0 across qompassai language repos.

**Consequence**: `LICENSE` = canonical apache.org text byte-identical
except appendix copyright line (e.g. `Copyright 2025 Qompass AI`).
README badge, SPDX `Apache-2.0` in metadata, Haskell DEP-5 updated.

## Rock grouping for the diver config (2026-10-09)

**Decision**: Ten rocks, not per-subsystem dozens — formatters+linters
merged (`diver-lintfmt`), config.ui+config.data merged (`diver-config`),
comms kept separate (self-contained). Dependency graph must stay
acyclic; cycles are resolved by hosting the shared module in the lower
rock, never by editing logic.

**Hosted-away-from-namesake modules** (names unchanged):
`security.rce`, `research.docs`, `config.core.parser` → diver-utils
(shared by several rocks); `ai.debugbridge.bsp` → diver-dev (it requires
`dev.bsp` at load; diver-ai cannot depend on diver-dev).

**Excluded from rocking**: LuaCATS stubs (`lua/types/**`), personal
config wiring (config.lang, mappings, nav, lazy/lsp, config.core except
parser), the `plugin/` filename-loaded shim, and three standalone
scripts (`dev/docs/lua_introspect.lua` ×2 copies,
`ai/herd/remote_query.lua` — the latter executes at load and reads stdin).

**Byte deviations from config sources** (exactly two): openalex.lua's
research-secret path is `vim.fn.expand('~/.local/bin/research-secret')`
instead of a hardcoded absolute path; a tic80 doc comment uses `~/`
instead of an absolute home path.

**Test shipping rule**: only tests that run standalone are shipped.
Full-config tests (self-declared in their headers) and tests referencing
nonexistent modules (`ai.security.pqc`) stay in the config only.
