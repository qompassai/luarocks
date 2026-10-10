# Current Work

Standalone LuaRocks distributions of the diver Neovim config's library
modules (ten `diver-*` rocks). Created 2026-10-09 from the
qompassai/lua-template template at Matt's direction.

## Status

- Initial release pushed: 845 of the config's 945 `lua/` modules rocked,
  grouped into utils, config, dap, games, lintfmt, research, security,
  comms, ai, dev (dependency order).
- Standalone gate passed before publishing: every rock installed into a
  fresh scratch tree with only its declared deps, every module required
  in bare Neovim (`-u NONE`) — 845/845; shipped tests green (research
  208/208; busted unit 248/2 = the config's own baseline, integration
  28/28; per-rock details in each rock's README).
- This repo is a distribution, not a cut-over: the diver config is the
  source of truth and is not modified by work here. Re-syncs from the
  config are deliberate, gated events.

## Standing rules

- License: Apache-2.0 (SPDX). `LICENSE` file byte-identical to canonical
  text except filled copyright line.
- Module names are preserved exactly (`utils.*`, `research.*`, …);
  shipped `.lua` files stay byte-identical to the config sources — any
  deviation is listed in the root README and in decisions.md.
- Do not push changes without Matt's explicit direction.
