<!-- qompassai/luarocks/README.md -->

# luarocks

> Standalone LuaRocks distributions of the diver Neovim config's library modules.

<a href="./LICENSE"><img src="https://img.shields.io/badge/License-Apache%202.0-blue.svg" alt="License: Apache 2.0"></a>

[diver](https://github.com/qompassai/diver) is a large Neovim configuration
whose Lua is organized as library-grade subsystems. This repo packages every
part of that config that can honestly stand alone as a **Lua rock** — grouped
logically into ten rocks, not dozens. Module names are preserved exactly
(`utils.*`, `research.*`, `security.*`, …) and the shipped `.lua` files are
byte-identical to the config sources, with two flagged exceptions (see
[Deviations](#deviations-from-the-config-sources)).

The config itself is unchanged: this repo is a standalone distribution, not
a cut-over. Nothing here is required by diver.

## The rocks

Install in the order listed — each rock only depends on rocks above it.

| # | Rock (package) | Purpose | Modules | Lines | Depends on |
|---|---|---|---|---|---|
| 1 | `utils` (`diver-utils`) | Foundations: `utils.*` shared helpers, `tools.*`, plus the shared primitives `security.rce` (safe-exec), `research.docs` (header builder), `config.core.parser` | 24 | 8,323 | — |
| 2 | `config` (`diver-config`) | Config library: `config.ui.*` (icons, image, themes, virtual text) and `config.data.*` (database adapters) | 31 | 30,845 | — |
| 3 | `dap` (`diver-dap`) | Debug-adapter suite: `dap.*` session engine, ~50 adapters, store, lifecycle, Moonwalk/phlow integrations | 69 | 51,494 | — |
| 4 | `games` (`diver-games`) | Game-engine tooling: `games.*` for Aseprite, Blender, Godot, LÖVE, Redot, TIC-80, Unity, Unreal, Voidsprite + shared character kit | 78 | 27,524 | — |
| 5 | `lintfmt` (`diver-lintfmt`) | Tool catalogs: `formatters.*` (138 adapters + engine) and `linters.*` (185 adapters + engine), one adapter per file | 323 | 64,913 | diver-utils |
| 6 | `research` (`diver-research`) | Research workflow: `research.*` journals, ORCID, OpenAlex, Web of Science, Zenodo, deadlines, watchlist, templates, Zotero | 25 | 13,573 | diver-utils |
| 7 | `security` (`diver-security`) | Security toolkit: `security.*` RCE/MiTM/zombie/supply-chain guards, red/blue suites, pass, Ghidra bridge, PQC | 39 | 12,350 | diver-utils, diver-config |
| 8 | `comms` (`diver-comms`) | Mail tooling: `comms.*` aerc/neomutt clients, mail + MIME helpers | 6 | 2,652 | diver-utils |
| 9 | `ai` (`diver-ai`) | AI suite: `ai.*` harness, MCP, ACP, A2A, herd, rose integration, media, recon; `salesforce.mcp` | 152 | 41,407 | diver-utils, diver-security, diver-dap |
| 10 | `dev` (`diver-dev`) | Developer tooling: `dev.*` BSP servers, SCIP indexers, browser (BiDi), apps, Salesforce suite, git/jj/cargo | 98 | 29,055 | diver-utils, diver-ai |

Three modules live in `diver-utils` rather than their namesake rock because
several rocks share them and the dependency graph must stay acyclic:
`security.rce`, `research.docs`, `config.core.parser`. Their module names
are unchanged. One more module is hosted by the rock that owns its hard
dependency: `ai.debugbridge.bsp` (which requires `dev.bsp` at load) ships
in `diver-dev`; its consumers in `ai.debugbridge` reach it lazily inside
`setup()`.

## Install

Native LuaRocks only — no plugin manager (no rocks.nvim). From a clone of
this repo, install each rock into a dedicated Lua 5.1 tree, in table order:

```sh
git clone https://github.com/qompassai/luarocks.git
cd luarocks
for rock in utils config dap games lintfmt research security comms ai dev; do
    (cd "$rock" && luarocks --lua-version=5.1 \
        --tree ~/.local/share/diver/luarocks \
        make diver-"${rock}"-0.1.0-1.rockspec)
done
```

(`lintfmt`'s rockspec filename is `diver-lintfmt-0.1.0-1.rockspec`; the loop
above already accounts for that since every package is `diver-<dirname>`.)

Then teach Neovim where the tree is. This is plain Lua in `init.lua`,
before anything requires the rocks — the pattern verified against the
config itself:

```lua
-- Native LuaRocks tree for the diver-* rocks (no plugin manager).
local tree = vim.fn.expand('~/.local/share/diver/luarocks')
package.path = tree .. '/share/lua/5.1/?.lua'
    .. ';' .. tree .. '/share/lua/5.1/?/init.lua'
    .. ';' .. package.path
package.cpath = tree .. '/lib/lua/5.1/?.so' .. ';' .. package.cpath
```

Each rock also carries a `README.md` with its full module list, and a
`tests/` directory where the config's own tests for those modules run
standalone (bare Neovim, `-u NONE`, only the rock tree on the path).

## What is not here, and why

845 of the config's 945 `lua/` modules are rocked. The rest are not
library code:

| Excluded | Count | Reason |
|---|---|---|
| `lua/types/**` | 33 | LuaCATS annotation stubs — config-internal typing, no runtime library value |
| `config.lang.*` | 29 | Per-language personal settings, entangled with formatters/linters/dap wiring |
| `config.mappings.*`, `config.nav.*`, `config.lazy`, `config.lsp`, `config` init, `config.core.*` (except `parser`) | 33 | Personal config wiring: keymaps, navigation, plugin/LSP bridges |
| `lua/plugin/**` | 2 | Filename-loaded runtime shim (Neovim `plugin/` convention) |
| `dev/docs/lua_introspect.lua`, `dev/docs/bin/lua_introspect.lua`, `ai/herd/remote_query.lua` | 3 | Standalone scripts executed as jobs / via `nvim -l` over ssh, not require-able modules (remote_query runs `main()` at load and reads its request from stdin) |

Filename-loaded runtime trees (`lsp/**`, `queries/**`, `after/**`,
`ftplugin/**`) were never candidates: Neovim finds those by filename on
the runtime path, not by `require`.

## Deviations from the config sources

Every shipped `.lua` file is byte-identical to its config source except:

1. `research/lua/research/openalex.lua` — the research-secret helper path
   was a hardcoded absolute home-directory path; it is now
   `vim.fn.expand('~/.local/bin/research-secret')`.
2. `games/lua/games/tic80/init.lua` — a doc-comment example referenced an
   absolute home-directory path; it now reads `~/tic80/game.lua`.

## Verification

Every rock passed a standalone gate before this repo was published: each
rock was installed into a fresh scratch LuaRocks tree with only its
declared dependencies present, then **every module in the rock was
required in bare Neovim** (`nvim -u NONE`, no config) — 845/845 across
the ten rocks — and the rock's included tests were run (research suite
208/208; harness busted suites 248 pass / 2 fail, identical to the
config's own baseline, integration 28/28; security suites 92 PASS;
bsp registry, games, and dap suites green — per-rock details in each
rock's README). A rock that only loads with the full config present
does not ship. Tests that are full-config tests by their own headers
were not shipped; each rock's README says which and why.

## License

This project is licensed under the [Apache License, Version 2.0](./LICENSE).

Copyright 2026 Qompass AI.
