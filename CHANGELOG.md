# Changelog — qompassai/luarocks

## 2026-10-09 — Initial release: ten diver-* rocks (0.1.0-1)

- Created from the `qompassai/lua-template` GitHub template (public, Apache-2.0).
- Packaged 845 of the diver Neovim config's 945 `lua/` modules as ten
  standalone LuaRocks, grouped logically: diver-utils, diver-config,
  diver-dap, diver-games, diver-lintfmt, diver-research, diver-security,
  diver-comms, diver-ai, diver-dev. Module names preserved exactly; files
  byte-identical to the config sources except two flagged deviations
  (see README).
- Every rock passed a standalone gate: installed into a fresh scratch
  LuaRocks tree with only its declared dependencies, every module required
  in bare Neovim (`-u NONE`), included tests run.
- Not rocked: LuaCATS type stubs, personal config wiring (lang settings,
  mappings, nav), the `plugin/` shim, and two standalone CLI scripts —
  rationale in the README.
