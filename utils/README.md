# diver-utils

Diver foundations: shared utility library (utils.*), tools.*, plus the shared primitives other diver rocks build on (security.rce safe-exec, research.docs header builder, config.core.parser).

Part of [qompassai/luarocks](https://github.com/qompassai/luarocks) — the
standalone LuaRocks distribution of the [diver](https://github.com/qompassai/diver)
Neovim config's library modules. Module names are identical to the config's
(`config.*` etc.), and the files are byte-identical to
the config sources except where the repo README's deviation list says otherwise.

- Modules: 24
- Lines: 8323
- Depends on: (none)

## Install

From a clone of the repo (native LuaRocks, no plugin manager):

```sh
cd utils
luarocks --lua-version=5.1 --tree ~/.local/share/diver/luarocks \
    make diver-utils-0.1.0-1.rockspec
```

Install dependency rocks first (see the repo README for the full order).
Then add the tree to Neovim's package path — see the repo README's
bootstrap snippet.

## Modules

- `config.core.parser`
- `research.docs`
- `security.rce`
- `tools`
- `tools.video`
- `utils`
- `utils.calendar`
- `utils.codeactions`
- `utils.ddx`
- `utils.encoder`
- `utils.hledger`
- `utils.json`
- `utils.notify`
- `utils.options`
- `utils.options.buffer`
- `utils.options.global`
- `utils.options.globals`
- `utils.options.window`
- `utils.rpc`
- `utils.shell`
- `utils.snippets`
- `utils.sync`
- `utils.tmux`
- `utils.toolmgr`

## Tests

`tests/lua/research_docs_make_header.lua` covers `research.docs` (hosted
in this rock). Plain-Lua harness (vim stub): run from the rock root with
`lua5.1 tests/lua/research_docs_make_header.lua`. Gate result: 22/22.
(The file sits under `tests/lua/` because its root locator requires that
layout.) The config's other utils suites (tmux, sync, notify) are
full-config tests by their own headers and are not shipped.
