# diver-dap

Diver debug-adapter suite: dap.* session engine, adapters, store, lifecycle and integrations (Moonwalk, phlow).

Part of [qompassai/luarocks](https://github.com/qompassai/luarocks) — the
standalone LuaRocks distribution of the [diver](https://github.com/qompassai/diver)
Neovim config's library modules. Module names are identical to the config's
(`dap.*` etc.), and the files are byte-identical to
the config sources except where the repo README's deviation list says otherwise.

- Modules: 69
- Lines: 51494
- Depends on: (none)

## Install

From a clone of the repo (native LuaRocks, no plugin manager):

```sh
cd dap
luarocks --lua-version=5.1 --tree ~/.local/share/diver/luarocks \
    make diver-dap-0.1.0-1.rockspec
```

Install dependency rocks first (see the repo README for the full order).
Then add the tree to Neovim's package path — see the repo README's
bootstrap snippet.

## Modules

- `dap`
- `dap._cmds`
- `dap.adapters.moonwalk`
- `dap.android`
- `dap.ansible`
- `dap.apex`
- `dap.async`
- `dap.backend`
- `dap.bash`
- `dap.breakpoints`
- `dap.cobol`
- `dap.cortex-debug`
- `dap.csharp`
- `dap.dap`
- `dap.dart`
- `dap.elixir`
- `dap.entity`
- `dap.erlang`
- `dap.ext.autocompl`
- `dap.ext.vscode`
- `dap.firefox`
- `dap.gdb`
- `dap.go`
- `dap.godot`
- `dap.haskell`
- `dap.integrations.moonwalk`
- `dap.integrations.phlow`
- `dap.java`
- `dap.kotlin`
- `dap.lifecycle`
- `dap.lldb`
- `dap.lldb-dap`
- `dap.log`
- `dap.lua`
- `dap.mojo`
- `dap.nix`
- `dap.node`
- `dap.ocaml`
- `dap.perl`
- `dap.php`
- `dap.postgres`
- `dap.powershell`
- `dap.probe-rs`
- `dap.progress`
- `dap.protocol`
- `dap.python`
- `dap.r`
- `dap.registry`
- `dap.registry.discovery`
- `dap.renderdoc`
- `dap.repl`
- `dap.rpc`
- `dap.ruby`
- `dap.rust`
- `dap.scala`
- `dap.session`
- `dap.sql`
- `dap.sqlite`
- `dap.store`
- `dap.store.common`
- `dap.store.postgresql`
- `dap.store.schema`
- `dap.store.sqlite`
- `dap.ui`
- `dap.ui.widgets`
- `dap.unity`
- `dap.unreal`
- `dap.utils`
- `dap.zig`

## Tests

`tests/lua/dap_ansible_role_breakpoints.lua` (47/47) and
`tests/lua/dap_ruby_rdbg.lua` (41/41) — plain-Lua harnesses (vim stub):
run from the rock root with `lua5.1 tests/lua/<file>`. They sit under
`tests/lua/` because their root locator requires that layout.
