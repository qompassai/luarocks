# diver-dev

Diver developer tooling: dev.* BSP servers, SCIP indexers, browser (BiDi/CDP), apps, Salesforce suite, git/jj/cargo runners.

Part of [qompassai/luarocks](https://github.com/qompassai/luarocks) — the
standalone LuaRocks distribution of the [diver](https://github.com/qompassai/diver)
Neovim config's library modules. Module names are identical to the config's
(`ai.*` etc.), and the files are byte-identical to
the config sources except where the repo README's deviation list says otherwise.

- Modules: 98
- Lines: 29055
- Depends on: diver-utils, diver-ai

## Install

From a clone of the repo (native LuaRocks, no plugin manager):

```sh
cd dev
luarocks --lua-version=5.1 --tree ~/.local/share/diver/luarocks \
    make diver-dev-0.1.0-1.rockspec
```

Install dependency rocks first (see the repo README for the full order).
Then add the tree to Neovim's package path — see the repo README's
bootstrap snippet.

## Modules

- `ai.debugbridge.bsp`
- `dev`
- `dev.ansible`
- `dev.apps`
- `dev.apps.android`
- `dev.apps.android.actions`
- `dev.apps.android.bsp`
- `dev.apps.android.commands`
- `dev.apps.android.config`
- `dev.apps.android.devices`
- `dev.apps.android.doctor`
- `dev.apps.android.fdroid`
- `dev.apps.android.gradle`
- `dev.apps.android.matrix`
- `dev.apps.android.output`
- `dev.apps.android.recent`
- `dev.apps.android.subsystems`
- `dev.apps.android.tools`
- `dev.apps.android.ui`
- `dev.apps.android.util`
- `dev.apps.catalog`
- `dev.apps.commands`
- `dev.audio`
- `dev.bootdev`
- `dev.browser`
- `dev.browser.bidi`
- `dev.browser.bidi.actions`
- `dev.browser.bidi.browsing_context`
- `dev.browser.bidi.commands`
- `dev.browser.bidi.config`
- `dev.browser.bidi.driver`
- `dev.browser.bidi.log`
- `dev.browser.bidi.network`
- `dev.browser.bidi.script`
- `dev.browser.bidi.session`
- `dev.browser.bidi.transport`
- `dev.browser.bidi.wire`
- `dev.browser.cdp`
- `dev.browser.cdp.actions`
- `dev.browser.cdp.commands`
- `dev.browser.cdp.domains`
- `dev.browser.cdp.security`
- `dev.browser.cdp.session`
- `dev.browser.http`
- `dev.bsp`
- `dev.bsp.commands`
- `dev.bsp.servers`
- `dev.bsp.servers.bazel`
- `dev.bsp.servers.bloop`
- `dev.bsp.servers.cargo`
- `dev.bsp.servers.gradle`
- `dev.bsp.servers.mill`
- `dev.bsp.servers.pants`
- `dev.bsp.servers.sbt`
- `dev.bsp.servers.scalacli`
- `dev.bsp.servers.swift`
- `dev.bsp.servers.util`
- `dev.cargo`
- `dev.cargo.init`
- `dev.docs`
- `dev.git`
- `dev.jj`
- `dev.refactor`
- `dev.refactor.core`
- `dev.refactor.debug`
- `dev.refactor.lsp`
- `dev.refactor.scip`
- `dev.scip`
- `dev.scip.config`
- `dev.scip.context`
- `dev.scip.health`
- `dev.scip.index`
- `dev.scip.lang`
- `dev.scip.query`
- `dev.scip.registry`
- `dev.scip.root`
- `dev.scip.state`
- `dev.scip.ui`
- `dev.scip.utils`
- `dev.sf`
- `dev.sf.agent`
- `dev.sf.analyzer`
- `dev.sf.apex`
- `dev.sf.core`
- `dev.sf.data`
- `dev.sf.org`
- `dev.sf.project`
- `dev.sf.secreview`
- `dev.sf.tasks`
- `dev.sf.trailhead`
- `dev.test`
- `dev.vulkan`
- `dev.vulkan.compile`
- `dev.vulkan.init`
- `dev.vulkan.lsp`
- `dev.vulkan.prompts`
- `dev.vulkan.sdk`
- `dev.vulkan.toolchain`

## Hosting note

This rock also hosts `ai.debugbridge.bsp` (module name unchanged): the BSP
bridge layer requires `dev.bsp` at load time, so it lives with the rock
that owns `dev.bsp`. Its consumers in `ai.debugbridge` (in `diver-ai`)
reach it lazily inside `setup()`.

## Tests

`tests/bsp/bsp_registry.lua` with fixtures under `tests/fixtures/bsp/`
passes in bare Neovim against the installed tree. Not shipped: the
config's dev/cargo and dev_apps suites — full-config tests by their own
headers (they assert the config's lazy `:Cargo*` command stubs).
