# Maintaining this fork

This repo is `littlecurtis/pstack`: a fork of [`backnotprop/pstack`](https://github.com/backnotprop/pstack) (itself a mirror of `cursor/plugins/pstack`), packaged as a Claude Code plugin and extended with Curtis's Life OS build loop. `MIRROR.md` describes how backnotprop tracks Cursor; this file describes how we track backnotprop.

## Install

```
/plugin marketplace add littlecurtis/pstack
/plugin install pstack@littlecurtis
```

Skills are namespaced `/pstack:<skill>`. Entry point: `/pstack:curtis-mode`.

## Two layers

**Layer 1: upstream, never edited.** Every file that also exists in `backnotprop/pstack` stays byte-identical to upstream. `how`, `tdd`, `show-me-your-work`, `unslop`, `teach`, the `principle-*` leaves, all playbooks. `git merge upstream/main` lands these with no conflicts because we never touch them. Skipped skills (`babysit`, `swarm`, `orchestrate`, …) stay too. They're inert; nothing of ours routes to them, and deleting them would only invite merge conflicts.

**Layer 2: ours, under new names.** Anything we adapt gets its own directory and a header naming its source and the upstream SHA it was derived from:

```
<!-- derived-from: skills/interrogate/SKILL.md @ 157aae3 -->
```

`skills/curtis-mode/` (from `poteto-mode`), `skills/lens-review/` (from `interrogate`), `skills/laravel-best-practices/` (from `principle-type-system-discipline`), `skills/test-behavior-pest/` (from `principle-test-behavior-not-implementation`), `agents/curtis-agent.md` (from `poteto-agent.md`). The upstream original stays next to it untouched.

The header is what makes upstream changes reviewable: `scripts/upstream-diff.sh` reads every `derived-from` header and shows what upstream changed in each source since the SHA we derived from.

## Monthly pull

```bash
git fetch upstream
git log --oneline HEAD..upstream/main          # read what changed
scripts/upstream-diff.sh                        # what changed in files we derived from
git merge upstream/main                         # Layer 1 lands clean
```

Then, per line the script prints: fold the upstream change into our Layer 2 file (and bump its `derived-from` SHA), or decide not to and bump the SHA anyway so it stops showing. Treat the merge as a row-9 change under `curtis-mode`: read the diff before it lands. These are prompts that run with tool access in every repo the plugin is installed in.

## Line endings

Upstream is LF. This clone lives on Windows and is also used from WSL. `.gitattributes` forces LF in the working tree on both sides so a merge never shows every file as modified. If `git status` from WSL ever lists every upstream file as `M` with no real diff (`git diff --ignore-cr-at-eol --stat` is empty), the tree has CRLF: run `git add --renormalize . && git checkout -- .` from Windows.

## Rules

- Never edit a Layer 1 file. If you need it different, copy it to a new name with a `derived-from` header.
- Never delete a Layer 1 file.
- `LICENSE` is upstream's (MIT, Lauren Tan). Layer 2 files carry the `derived-from` header as attribution. Wholly new files (lens rubrics, vault templates) need no header.
- Pin: the SHA we last merged is `git merge-base HEAD upstream/main`. No lock file needed.
