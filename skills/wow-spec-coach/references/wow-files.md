# The player's WoW install

## Find it

| OS | Usual `_retail_` path |
|---|---|
| Windows | `C:\Program Files (x86)\World of Warcraft\_retail_` |
| macOS | `/Applications/World of Warcraft/_retail_` |
| Linux | inside a Wine/Proton prefix (`drive_c/Program Files (x86)/World of Warcraft/_retail_`) or a separate drive the prefix maps |

On Linux/macOS: `find / -maxdepth 6 -type d -name _retail_ 2>/dev/null | grep -i warcraft`. Windows prefixes from Lutris, Faugus, Bottles or Steam can also map a Windows drive letter to a Linux mount (`dosdevices/`).

## Read before acting

| What | Where | Why |
|---|---|---|
| Client version | `../.build.info` (the line ending in `wow`, e.g. `12.1.0.69933`) | `## Interface:` = major·10000 + minor·100 + patch (12.1.0 → `120100`) |
| Client language | `WTF/Config.wtf` `SET textLocale`, or the `.build.info` tags | Macro text and spell names must match it |
| Characters | `WTF/Account/<ACCOUNT>/<Realm>/<Character>/` | Ask which one when there are several |
| Class of a character | ElvUI's `SavedVariables/ElvUI.lua` has a `["class"]` table; otherwise ask | |
| Enabled addons | `<Character>/AddOns.txt` (can be stale) and the `Interface/AddOns` folder (truth) | |
| Action bar addon | `Interface/AddOns`: ElvUI, Bartender4, Dominos, or none (Blizzard bars) | Decides binding commands |
| Current keybinds | `WTF/Account/<ACCOUNT>/bindings-cache.wtf` (account) and `<Character>/bindings-cache.wtf` (character-specific) | Reveals movement keys, modifiers, habits |
| Macros | `macros-cache.txt` at account and character level | 120 account / 18 character macro limit |
| Is WoW running? | `pgrep -fai 'wow(-64)?\.exe'` (Linux/macOS), `tasklist /fi "imagename eq Wow.exe"` (Windows) | Changes how you install |

## Rules

- Never edit anything in `WTF/` while the game is running: it rewrites those files on logout and `/reload`.
- Writing a **new** addon folder needs a full client restart before the game sees it. Changing files of an addon the game already knows only needs `/reload`.
- Keybinds and action bars are stored on Blizzard's servers. Push changes through the addon in-game (`SetBinding`, `PlaceAction`), never by editing the caches.

## Bars and binding commands

`SpecKeys` maps each 12-slot action page (`page = floor((slot - 1) / 12)`) to a binding command prefix.

| Page | Slots | Blizzard bar | ElvUI bar | Binding prefix |
|---|---|---|---|---|
| 0 | 1-12 | Action Bar 1 | Bar 1 | `ACTIONBUTTON` |
| 1 | 13-24 | (page 2 of bar 1, not bindable) | Bar 2 | `ELVUIBAR2BUTTON` (ElvUI only) |
| 2 | 25-36 | Action Bar 4 (right) | Bar 3 | `MULTIACTIONBAR3BUTTON` |
| 3 | 37-48 | Action Bar 5 (right 2) | Bar 4 | `MULTIACTIONBAR4BUTTON` |
| 4 | 49-60 | Action Bar 3 (bottom right) | Bar 5 | `MULTIACTIONBAR2BUTTON` |
| 5 | 61-72 | Action Bar 2 (bottom left) | Bar 6 | `MULTIACTIONBAR1BUTTON` |
| 6-9 | 73-120 | stance / form / stealth pages of bar 1 | Bars 7-10 | `ELVUIBAR7..10BUTTON` |
| 12-14 | 145-180 | Action Bars 6-8 | Bars 13-15 | `MULTIACTIONBAR5..7BUTTON` |

- Blizzard bars beyond bar 1 must be turned on in Options › Gameplay › Action Bars; tell the user which ones.
- Check which ElvUI bars are enabled and how many buttons they show: the active profile is `ElvDB.profileKeys["<Char> - <Realm>"]`; an `actionbar.barN` table that doesn't set `enabled` or `buttons` uses ElvUI's defaults. Verify the prefixes in `ElvUI/Game/Shared/Modules/ActionBars/ActionBars.lua` (`bindButtons`).
- Avoid pages 6-9 on classes whose bar 1 swaps with stances or forms (Druid, Rogue, ...). Those slots are their form bars.
- Bar 1 itself swaps pages in forms and stealth: for those specs, put the forms' rotation into the matching form page or keep bar 1 for buttons that work everywhere.
- Other bar addons (Bartender4, Dominos): grep their installed source for the binding they register (`CLICK BT4Button%d:Keybind` style) and set `bind = "..."` on each layout entry, or pass `ui = { [page] = "PREFIX" }`.

## Keeping it safe

| Thing | Stored | Survives reinstall? |
|---|---|---|
| Keybinds | Blizzard servers (+ local cache) | yes |
| Action bars (per spec) | Blizzard servers | yes |
| Macros | Blizzard servers (+ local cache) | yes |
| Addon settings (ElvUI, Details, ...) | `WTF/.../SavedVariables` only | **no**: back these up |
| The layout itself | `Interface/AddOns/SpecKeys/Layouts.lua` | back it up; `/speckeys` rebuilds everything |

Backup after `/reload` or logout (the game writes the files then):
```bash
tar czf ~/wow-ui-$(date +%F).tgz -C "<_retail_>" WTF Interface/AddOns/SpecKeys
```
Also: ElvUI `/ec` › Profiles › Export (Profile + Private) gives paste-able strings, and the Myslot addon exports bars + binds + macros as one string (useful after hand-made changes).
