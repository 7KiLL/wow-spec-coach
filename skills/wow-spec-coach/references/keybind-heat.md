# Keybinds by usage heat

The most-pressed buttons go on the easiest keys next to the movement keys, so the player never stops moving to cast. Rarely used buttons go further away or behind a modifier.

## 1. Rank the spec's buttons

Sort every button you will bind into one of these classes, using the guide's rotation and cooldown pages:

| Class | Typical buttons | How often |
|---|---|---|
| Spam | filler, main spender, proc spender | every GCD or close to it |
| Rotational | short cooldowns (≤ 30 s), DoT refresh, AoE button | several times a minute |
| Reaction | interrupt, stun, dispel, dodge/teleport | unpredictable, must be instant |
| Cooldown | 1-3 min damage cooldowns, potions, trinkets | once or twice a fight |
| Defensive | personal defensives, heals, healthstone | on demand, under pressure |
| Utility | CC, curses, movement buffs, battle res, portals | situational |
| Out of combat | food, summons, buffs, portals, soulwell | before pulls |

Inside each class, order by presses per minute. A button that replaces itself through a talent (proc or hero-talent overrides) is one button. Say clearly that the order is an estimate from the rotation, not a measurement.

## 2. Rank the keys

For WASD movement (W and A/S/D are taken), from hottest to coldest:

| Tier | Keys (left to right) |
|---|---|
| 1 | Q, E, R |
| 2 | F, 1, 2, 3 |
| 3 | T, G, 4, Shift+Q, Shift+E, Shift+R |
| 4 | Z, X, C, V, Shift+F, Shift+1..4 |
| 5 | 5, Shift+T, Shift+G, Shift+Z..V, Ctrl+Q/E/R |
| 6 | other Ctrl/Alt combos, far keys (6+, B, Y, H) |

ESDF movement shifts everything one key right: W, R, T are tier 1; A, G, 2-4 tier 2; and so on. Mouse side buttons, when the player has them, are tier 1-2 and best for reaction buttons. With an MMO mouse, put the rotation on the grid and keep the keyboard for the rest.

## 3. Assign

1. Fill tiers in order, **left to right inside a tier** (rank 1 → Q, rank 2 → E, rank 3 → R) unless the player chose "closest to movement first".
2. Reaction buttons take F/G/T (or side buttons): fast, and not where a mis-press costs a cooldown.
3. Damage cooldowns go on the number row in the order the opener presses them, so the burst reads left to right.
4. Defensives go on the bottom row (Z X C V); the biggest one gets the easiest key.
5. The Shift layer reuses the same key for a related button where it makes sense (spell on F, its teleport on Shift+F). Ctrl holds out-of-combat buttons.
6. Keep what already works: if the player's current binds (from `bindings-cache.wtf`) already put the bar on Q/E/R/F, keep those key positions and only change what sits behind them.
7. Leave one or two keys free and say which.

## 4. Bars

- One modifier layer per bar: bar 1 = no modifier, bar 2 = Shift (ElvUI) or the next enabled bar, then an overflow bar for the rest and Ctrl.
- Slot order on a bar follows key order, left to right (Q, E, R, T, F, G, 1, 2, 3, 4, Z, X), so the bar looks like the keyboard.
- Only use bars the player has enabled and buttons that are visible (an ElvUI bar showing 10 buttons hides slots 11-12).

## 5. Macros worth making

| Macro | Body (use `{spellID}` for names) |
|---|---|
| Ground spell at the cursor | `#showtooltip\n/cast [@cursor] {id}` |
| Helpful spell on mouseover, else target | `#showtooltip {id}\n/cast [@mouseover,help,exists][] {id}` |
| Interrupt on focus, else target | `#showtooltip {id}\n/cast [@focus,harm,nodead][] {id}` |
| Main cooldown + top trinket | `#showtooltip {id}\n/use 13\n/cast {id}` (top trinket slot; a passive trinket does nothing) |
| Potion or healthstone | `#showtooltip\n/use <item name>` (names match every crafted rank; `item:ID` matches one rank) |

Keep macro names ≤ 16 characters and bodies ≤ 255. The per-character macro limit is 18, so check `macros-cache.txt` before adding many.

## 6. Show it

Give the player the layout as a keyboard heatmap (in the page, or as a table in chat), grouped by class, with one line per key on why it sits there.
