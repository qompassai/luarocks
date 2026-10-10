# diver-games

Diver game-engine tooling: games.* for Aseprite, Blender, Godot, LÖVE, Redot, TIC-80, Unity, Unreal and Voidsprite, plus shared character kit.

Part of [qompassai/luarocks](https://github.com/qompassai/luarocks) — the
standalone LuaRocks distribution of the [diver](https://github.com/qompassai/diver)
Neovim config's library modules. Module names are identical to the config's
(`games.*` etc.), and the files are byte-identical to
the config sources except where the repo README's deviation list says otherwise.

- Modules: 78
- Lines: 27524
- Depends on: (none)

## Install

From a clone of the repo (native LuaRocks, no plugin manager):

```sh
cd games
luarocks --lua-version=5.1 --tree ~/.local/share/diver/luarocks \
    make diver-games-0.1.0-1.rockspec
```

Install dependency rocks first (see the repo README for the full order).
Then add the tree to Neovim's package path — see the repo README's
bootstrap snippet.

## Modules

- `games`
- `games.aseprite`
- `games.aseprite.actions`
- `games.aseprite.character`
- `games.aseprite.commands`
- `games.aseprite.config`
- `games.aseprite.import`
- `games.aseprite.prompts`
- `games.aseprite.util`
- `games.blender`
- `games.blender.actions`
- `games.blender.batch`
- `games.blender.character`
- `games.blender.commands`
- `games.blender.config`
- `games.blender.export`
- `games.blender.health`
- `games.blender.render`
- `games.blender.sprites`
- `games.blender.versions`
- `games.godot`
- `games.godot.character`
- `games.health`
- `games.love2d`
- `games.love2d.actions`
- `games.love2d.adapters`
- `games.love2d.adapters.aseprite`
- `games.love2d.adapters.blender`
- `games.love2d.adapters.godot`
- `games.love2d.adapters.redot`
- `games.love2d.adapters.unity`
- `games.love2d.adapters.unreal`
- `games.love2d.apidefs.love`
- `games.love2d.character`
- `games.love2d.commands`
- `games.love2d.config`
- `games.love2d.dev`
- `games.love2d.health`
- `games.love2d.libs`
- `games.love2d.package`
- `games.love2d.release`
- `games.love2d.versions`
- `games.redot`
- `games.redot.character`
- `games.robocode`
- `games.robocode.actions`
- `games.robocode.commands`
- `games.robocode.config`
- `games.robocode.health`
- `games.shared.async_util`
- `games.shared.character`
- `games.shared.events`
- `games.shared.godot_engine`
- `games.shared.output`
- `games.shared.ui`
- `games.shared.util`
- `games.tic80`
- `games.tic80.actions`
- `games.tic80.commands`
- `games.tic80.config`
- `games.tic80.util`
- `games.unity`
- `games.unity.actions`
- `games.unity.character`
- `games.unity.commands`
- `games.unity.config`
- `games.unity.util`
- `games.unreal`
- `games.unreal.actions`
- `games.unreal.character`
- `games.unreal.commands`
- `games.unreal.config`
- `games.unreal.util`
- `games.voidsprite`
- `games.voidsprite.actions`
- `games.voidsprite.commands`
- `games.voidsprite.config`
- `games.voidsprite.util`

## Tests

`tests/games/` — run in bare Neovim with the installed tree on the path.
Gate results: character_kit passes; love2d_core 20/20;
character_engines 50/56 — the 6 failing adversarial checks assume the
engine binaries (blender/godot/redot/aseprite) are absent and fail
identically against the config's own sources on a machine where they are
installed; all 28 validation checks pass.
