# diver-comms

Diver mail tooling: comms.* clients (aerc, neomutt), mail and MIME helpers.

Part of [qompassai/luarocks](https://github.com/qompassai/luarocks) — the
standalone LuaRocks distribution of the [diver](https://github.com/qompassai/diver)
Neovim config's library modules. Module names are identical to the config's
(`comms.*` etc.), and the files are byte-identical to
the config sources except where the repo README's deviation list says otherwise.

- Modules: 6
- Lines: 2652
- Depends on: diver-utils

## Install

From a clone of the repo (native LuaRocks, no plugin manager):

```sh
cd comms
luarocks --lua-version=5.1 --tree ~/.local/share/diver/luarocks \
    make diver-comms-0.1.0-1.rockspec
```

Install dependency rocks first (see the repo README for the full order).
Then add the tree to Neovim's package path — see the repo README's
bootstrap snippet.

## Modules

- `comms`
- `comms.clients`
- `comms.clients.aerc`
- `comms.clients.neomutt`
- `comms.mail`
- `comms.mime`

## Tests

None shipped: the config's email-clients suite is a full-config test by
its own header and still uses the pre-rename `email.*` module names. All
6 modules passed the standalone require gate.
