# wow-spec-coach

An agent skill that turns a World of Warcraft class guide into your personal setup. Drop a Wowhead (or Icy Veins, Maxroll, ...) link, answer a few questions, and get:

- **An ADHD-friendly guide**: your 3 core buttons first, a 5-level learning path with drills and time estimates, "if this, press that" fixes, and the why behind every talent kept one click away.
- **Talent import strings** for the content you play (raid, Mythic+, delves, leveling).
- **Keybinds by usage heat**: the most-pressed buttons on the easiest keys next to your movement keys.
- **An in-game addon (`SpecKeys`)**: `/speckeys` puts the spells on your action bars and binds the keys. It works with ElvUI or Blizzard bars and any client language.
- **An optional visual guide page** with a keyboard heatmap and copy buttons for the import strings.
- **A backup plan**: what's stored where, and how to keep it.

## Install

```bash
npx skills add 7KiLL/wow-spec-coach -g -a claude-code
```

This works with any agent the [`skills`](https://github.com/vercel-labs/skills) CLI supports; drop `-a claude-code` to choose interactively.

Recommended: [`agent-browser`](https://github.com/vercel-labs/agent-browser) for reading guides, and Lua 5.1+ (`lua`, `lua5.1` or `luajit`) so the agent can validate layouts before you log in.

## Use

```
https://www.wowhead.com/guide/classes/warlock/demonology/overview-pve-dps
```

Paste a link (or say "set me up for Demonology"). The agent reads the guide, finds your WoW install and characters, asks two short rounds of questions (content, hero tree, what to build; then movement keys, mouse buttons, modifiers), and walks you through the in-game steps.

## SpecKeys

```
Interface/AddOns/SpecKeys/
  Core.lua      engine: places actions, binds keys, saves binds character-specific
  Layouts.lua   one entry per class + spec, written by the agent
```

- `/speckeys` applies the layout for your current class and spec. Run it again after a talent swap.
- Binds are saved **character-specific**, so your other characters keep theirs. Undo: Options › Keybindings › untick *Character Specific Keybindings*.
- Spell IDs make it work in any client language; `{spellID}` in a macro body becomes the localized name.
- It only touches the slots and keys in the layout.

Validate layouts outside the game:

```bash
lua skills/wow-spec-coach/scripts/check_layouts.lua skills/wow-spec-coach/addon/SpecKeys
```

## Notes

- The agent never edits `WTF/` while WoW is running; keybinds and bars go through the game's own API.
- Heatmaps are estimated from the guide's rotation, not measured from your logs.
- Guides change every patch. The agent reports the guide's patch and date next to your client version.

## License

MIT
