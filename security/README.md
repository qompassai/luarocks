# diver-security

Diver security toolkit: security.* RCE/MiTM/zombie/supply-chain guards, red/blue suites, pass integration, Ghidra bridge, PQC tokens.

Part of [qompassai/luarocks](https://github.com/qompassai/luarocks) — the
standalone LuaRocks distribution of the [diver](https://github.com/qompassai/diver)
Neovim config's library modules. Module names are identical to the config's
(`security.*` etc.), and the files are byte-identical to
the config sources except where the repo README's deviation list says otherwise.

- Modules: 39
- Lines: 12350
- Depends on: diver-utils, diver-config

## Install

From a clone of the repo (native LuaRocks, no plugin manager):

```sh
cd security
luarocks --lua-version=5.1 --tree ~/.local/share/diver/luarocks \
    make diver-security-0.1.0-1.rockspec
```

Install dependency rocks first (see the repo README for the full order).
Then add the tree to Neovim's package path — see the repo README's
bootstrap snippet.

## Modules

- `security`
- `security.adapter_policy`
- `security.ai`
- `security.annotations`
- `security.auditlog`
- `security.blue`
- `security.blue.base64`
- `security.blue.dap`
- `security.blue.gpg`
- `security.blue.sops`
- `security.blue.ssh`
- `security.bounty`
- `security.bounty.dashboard`
- `security.bounty.gates`
- `security.bounty.profiles`
- `security.bounty.recon`
- `security.bounty.report`
- `security.bounty.scope`
- `security.bounty.submit`
- `security.commands`
- `security.container`
- `security.ghidra`
- `security.guard`
- `security.mask`
- `security.mcp_vet`
- `security.mitm`
- `security.pass`
- `security.patterns`
- `security.pqc`
- `security.prng`
- `security.red`
- `security.red.red`
- `security.red.shark`
- `security.red.tomcat`
- `security.scanner`
- `security.sshfs`
- `security.supplychain`
- `security.token`
- `security.zombie`

## Tests

`tests/security/` — guard 25 PASS, mask 13 PASS, ghidra 32 PASS,
ghidra_adversarial 22 PASS in bare Neovim against the installed tree
(fixtures under `tests/fixtures/ghidra/`). Not shipped: the pass/pqc
suites — pass.lua is a full-config test by its header, and both pqc
suites reference `ai.security.pqc`, a module path that does not exist in
the current tree (pre-existing failures in the config as well).
