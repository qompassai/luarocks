# diver-ai

Diver AI suite: ai.* harness (registry/supervisor/policy), MCP, ACP, A2A, herd, rose integration, media, recon, plus salesforce.mcp.

Part of [qompassai/luarocks](https://github.com/qompassai/luarocks) — the
standalone LuaRocks distribution of the [diver](https://github.com/qompassai/diver)
Neovim config's library modules. Module names are identical to the config's
(`ai.*` etc.), and the files are byte-identical to
the config sources except where the repo README's deviation list says otherwise.

- Modules: 152
- Lines: 41407
- Depends on: diver-utils, diver-security, diver-dap

## Install

From a clone of the repo (native LuaRocks, no plugin manager):

```sh
cd ai
luarocks --lua-version=5.1 --tree ~/.local/share/diver/luarocks \
    make diver-ai-0.1.0-1.rockspec
```

Install dependency rocks first (see the repo README for the full order).
Then add the tree to Neovim's package path — see the repo README's
bootstrap snippet.

## Modules

- `ai`
- `ai.a2a`
- `ai.a2a.agent_card`
- `ai.a2a.client`
- `ai.a2a.commands`
- `ai.a2a.fanout`
- `ai.a2a.orchestrator`
- `ai.a2a.sdk_drivers`
- `ai.a2a.sdks`
- `ai.a2a.tasks`
- `ai.a2a.ui`
- `ai.acp`
- `ai.acp.commands`
- `ai.acp.health`
- `ai.acp.permissions`
- `ai.acp.protocol`
- `ai.acp.registry`
- `ai.acp.rpc`
- `ai.acp.session`
- `ai.acp.store`
- `ai.acp.ui`
- `ai.agx`
- `ai.builder`
- `ai.builder.commands`
- `ai.builder.menu`
- `ai.builder.pipeline`
- `ai.builder.scip`
- `ai.builder.writer`
- `ai.bulk`
- `ai.cache.tiered`
- `ai.context`
- `ai.dataaccess`
- `ai.dataaccess.api`
- `ai.dataaccess.commands`
- `ai.dataaccess.confirm`
- `ai.dataaccess.log`
- `ai.dataaccess.paths`
- `ai.dataaccess.scan`
- `ai.dataaccess.scip`
- `ai.dataaccess.secrets`
- `ai.dataaccess.sessions`
- `ai.dataaccess.ui`
- `ai.debugbridge`
- `ai.debugbridge.api`
- `ai.debugbridge.commands`
- `ai.debugbridge.log`
- `ai.debugbridge.scanbreak`
- `ai.debugbridge.sessions`
- `ai.debugbridge.ui`
- `ai.harness`
- `ai.harness.adapter`
- `ai.harness.adapters.a2a`
- `ai.harness.adapters.acp`
- `ai.harness.adapters.herd`
- `ai.harness.adapters.mcp`
- `ai.harness.adapters.phlow`
- `ai.harness.adapters.rose`
- `ai.harness.approval`
- `ai.harness.budget`
- `ai.harness.context`
- `ai.harness.events`
- `ai.harness.health`
- `ai.harness.policy`
- `ai.harness.registry`
- `ai.harness.sandbox`
- `ai.harness.store`
- `ai.harness.supervisor`
- `ai.harness.telemetry`
- `ai.harness.types`
- `ai.harness.verdict`
- `ai.herd`
- `ai.herd.api`
- `ai.herd.catalog`
- `ai.herd.commands`
- `ai.herd.personas`
- `ai.herd.remotes`
- `ai.herd.tmux`
- `ai.herd.ui`
- `ai.herd.watch`
- `ai.huggingface`
- `ai.huggingface.api`
- `ai.inference.kv_policy`
- `ai.inference.speculative`
- `ai.mcp`
- `ai.mcp.client`
- `ai.mcp.commands`
- `ai.mcp.declared`
- `ai.mcp.declared_servers`
- `ai.mcp.discovery`
- `ai.mcp.registry`
- `ai.mcp.secrets`
- `ai.mcp.server`
- `ai.mcp.server.policy`
- `ai.mcp.server.protocol`
- `ai.mcp.server.stdio`
- `ai.mcp.server.tools`
- `ai.mcp.skills`
- `ai.mcp.tools`
- `ai.mcp.ui`
- `ai.mcp.webmcp`
- `ai.media`
- `ai.media.commands`
- `ai.media.image_provider`
- `ai.media.registry`
- `ai.media.tts_local`
- `ai.media.ui`
- `ai.media.video_probe`
- `ai.model_request`
- `ai.phlow`
- `ai.phlow.client`
- `ai.phlow.schemas`
- `ai.phlow.transports`
- `ai.recon`
- `ai.recon.commands`
- `ai.recon.gate`
- `ai.recon.parse`
- `ai.recon.rocks`
- `ai.recon.tools`
- `ai.retrieval.scip`
- `ai.retrieval.two_stage`
- `ai.rose`
- `ai.rose.agent`
- `ai.rose.bridge`
- `ai.rose.commands`
- `ai.rose.config`
- `ai.rose.flow`
- `ai.rose.http`
- `ai.rose.logger`
- `ai.rose.mcp`
- `ai.rose.model`
- `ai.rose.ollama`
- `ai.rose.provider.openai`
- `ai.rose.providers`
- `ai.rose.providers.anthropic`
- `ai.rose.providers.chat`
- `ai.rose.providers.common`
- `ai.rose.providers.responses`
- `ai.rose.providers.sse`
- `ai.rose.providers.transport`
- `ai.rose.readonly_tools`
- `ai.rose.servers`
- `ai.rose.tools`
- `ai.rose.ui`
- `ai.rose.utils`
- `ai.rose.validation`
- `ai.sched`
- `ai.webmcp.bridge`
- `ai.websocket`
- `ai.websocket.client`
- `ai.websocket.frame`
- `ai.websocket.server`
- `salesforce.mcp`

## Hosting note

`ai.debugbridge.bsp` ships in the `dev` rock (`diver-dev`), not here: it
requires `dev.bsp` at load time, and `diver-dev` is the rock that owns that
dependency (the reverse dependency would make the graph cyclic). The rest
of `ai.debugbridge` is here and loads standalone; it reaches the bsp layer
lazily inside `setup()`, so install `diver-dev` as well if you use the
debug bridge's BSP layer.

## Tests

`tests/busted/` — the config's busted suites for the harness/MCP layer,
with the config's own `.busted` at this rock's root. Run from the rock
root under plain Lua 5.1: `busted --run=unit`, `busted --run=integration`.
Gate results: unit 248 pass / 2 fail — byte-for-byte the config's own
baseline (the 2 failures are the known order-dependent specs,
mcp_declared_spec and verdict_spec, which pass in isolation);
integration 28/28.
