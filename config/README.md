# diver-config

Diver config library modules: config.ui.* (UI library: icons, image rendering, themes, virtual text) and config.data.* (database adapters).

Part of [qompassai/luarocks](https://github.com/qompassai/luarocks) — the
standalone LuaRocks distribution of the [diver](https://github.com/qompassai/diver)
Neovim config's library modules. Module names are identical to the config's
(`config.*` etc.), and the files are byte-identical to
the config sources except where the repo README's deviation list says otherwise.

- Modules: 31
- Lines: 30845
- Depends on: (none)

## Install

From a clone of the repo (native LuaRocks, no plugin manager):

```sh
cd config
luarocks --lua-version=5.1 --tree ~/.local/share/diver/luarocks \
    make diver-config-0.1.0-1.rockspec
```

Install dependency rocks first (see the repo README for the full order).
Then add the tree to Neovim's package path — see the repo README's
bootstrap snippet.

## Modules

- `config.data`
- `config.data.adapter`
- `config.data.common`
- `config.data.csv`
- `config.data.duckdb`
- `config.data.mariadb`
- `config.data.mysql`
- `config.data.psql`
- `config.data.redis`
- `config.data.sql`
- `config.data.sqlite`
- `config.ui`
- `config.ui.cmdline`
- `config.ui.colors`
- `config.ui.decor`
- `config.ui.float`
- `config.ui.icons`
- `config.ui.illuminate`
- `config.ui.image`
- `config.ui.line`
- `config.ui.lsp_health`
- `config.ui.nb`
- `config.ui.nerd`
- `config.ui.padding`
- `config.ui.render`
- `config.ui.startup_profile`
- `config.ui.themes`
- `config.ui.transparency`
- `config.ui.ui`
- `config.ui.vt`
- `config.ui.w3m`

## Tests

None shipped: the config's `config.ui` test suites (calendar, ui_icons)
declare themselves full-config tests ("never -u NONE") in their headers.
All 31 modules passed the standalone require gate.
