# diver-research

Diver research workflow: research.* journal registry, ORCID, OpenAlex, Web of Science, Zenodo, deadlines, watchlist, templates, Zotero.

Part of [qompassai/luarocks](https://github.com/qompassai/luarocks) — the
standalone LuaRocks distribution of the [diver](https://github.com/qompassai/diver)
Neovim config's library modules. Module names are identical to the config's
(`research.*` etc.), and the files are byte-identical to
the config sources except where the repo README's deviation list says otherwise.

- Modules: 25
- Lines: 13573
- Depends on: diver-utils

## Install

From a clone of the repo (native LuaRocks, no plugin manager):

```sh
cd research
luarocks --lua-version=5.1 --tree ~/.local/share/diver/luarocks \
    make diver-research-0.1.0-1.rockspec
```

Install dependency rocks first (see the repo README for the full order).
Then add the tree to Neovim's package path — see the repo README's
bootstrap snippet.

## Modules

- `research`
- `research.ama`
- `research.bib`
- `research.citation`
- `research.clipboard`
- `research.deadlines`
- `research.diff`
- `research.discover`
- `research.equations`
- `research.journal`
- `research.latex`
- `research.license`
- `research.manuscript`
- `research.markdown`
- `research.openalex`
- `research.orcid`
- `research.pdf`
- `research.research`
- `research.review`
- `research.submission`
- `research.templates`
- `research.watchlist`
- `research.wos`
- `research.zenodo`
- `research.zotero`

## Tests

`tests/research/research_journal_workflow.lua` — the config's full
research suite (journals, ORCID, OpenAlex, WoS, Zenodo, deadlines,
watchlist, templates, submission): 208/208 in bare Neovim against the
installed tree, identical to the in-config result.
