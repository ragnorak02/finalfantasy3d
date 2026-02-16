# Achievement System Integration Guide

## Overview

This document defines the contract for integrating `achievements.json` into
the game's runtime UI. It is engine-agnostic where possible and specifies
behavior, not implementation.

---

## Data Source

- **File:** `/achievements.json` (project root)
- **Format:** JSON, schema defined in this repository
- **Runtime access:** Load once at game start, hold in memory, write back on unlock

---

## Menu Integration

### Recommended Setup

| Property | Value |
|----------|-------|
| Menu label | **Achievements** |
| Placement | Main Menu, between "Options" and "Quit" |
| Also accessible from | Pause Menu (read-only list) |
| Controller nav | Fully navigable with D-Pad / stick |
| Keyboard shortcut | None required (menu-driven) |

### Menu Panel Layout

```
+------------------------------------------+
|  ACHIEVEMENTS              12 / 20  (60%) |
|  Points: 145 / 275                        |
|  [=========>          ]                   |
|------------------------------------------|
|  [*] First Steps            5 pts   Done |
|  [*] First Blood           10 pts   Done |
|  [ ] Combo Novice          10 pts        |
|  [ ] Heavy Hitter          15 pts        |
|  ...                                     |
+------------------------------------------+
```

- Show all achievements in definition order
- Unlocked achievements show checkmark + unlock date
- Locked achievements show lock icon + description
- Points displayed per-row and as running total
- Scroll if list exceeds visible area

---

## Unlock Flow

When gameplay code determines an achievement condition is met:

```
1. Check achievements.json data (in memory) for the target id
2. If already unlocked → do nothing (idempotent)
3. If locked:
   a. Set unlocked = true
   b. Set unlockedAt = current ISO timestamp
   c. Recalculate meta.totalPointsEarned
   d. Set meta.lastUpdated = current ISO timestamp
   e. Persist to achievements.json
   f. Emit signal: Events.achievement_unlocked(achievement_id)
   g. Trigger toast overlay (see below)
```

### Suggested Signal

Add to the `Events` autoload:

```gdscript
signal achievement_unlocked(achievement_id: String)
```

Gameplay systems connect to this for reactions (sound effects, particle bursts, etc.).

---

## Toast Overlay Specification

When an achievement unlocks, display a non-blocking popup notification.

### Visual Layout

```
+--------------------------------------+
|  [icon]  Achievement Unlocked!       |
|          Heavy Hitter     +15 pts    |
+--------------------------------------+
```

### Behavior

| Property | Value |
|----------|-------|
| Position | Top-center of screen |
| Animation | Slide down from off-screen, pause, slide up to dismiss |
| Display duration | **3 seconds** (configurable) |
| Dismiss | Auto-dismiss; no user interaction required |
| Queue | If multiple unlock simultaneously, queue and show sequentially |
| Z-order | Above all game UI, below engine debug overlays |
| Process mode | `PROCESS_MODE_ALWAYS` (visible even during tactical slow-time) |

### Content

| Element | Source |
|---------|--------|
| Icon | `achievement.icon` path (fall back to default trophy icon if missing) |
| Title | Fixed text: "Achievement Unlocked!" |
| Name | `achievement.name` |
| Points | `+{achievement.points} pts` |

### Audio

Play a distinct achievement jingle/chime via `AudioManager.play_sfx()` when the
toast appears. Use a dedicated audio asset (e.g., `assets/audio/sfx/achievement_unlock.wav`).

---

## Safe Update Rules

These rules MUST be followed when modifying `achievements.json`:

1. **Append only** — New achievements are added to the end of the array
2. **Never remove** — Existing achievement entries must never be deleted
3. **Never reset** — If `unlocked` is `true`, it must stay `true`
4. **Never rewrite `unlockedAt`** — Once set to a timestamp, do not change it
5. **Recalculate totals** — Always recompute `meta.totalPointsEarned` from actual unlocked states
6. **Update timestamp** — Always set `meta.lastUpdated` to current ISO time on any write
7. **Unique IDs** — Every `id` must be unique within the `achievements` array
8. **Integer points** — `points` must always be a positive integer

### Adding New Achievements (Future)

```json
{
  "id": "new_unique_id",
  "name": "Display Name",
  "description": "What the player must do",
  "points": 10,
  "icon": "assets/textures/ui/ach_new_unique_id.png",
  "unlocked": false,
  "unlockedAt": null
}
```

Append to the `achievements` array. Update `meta.totalPointsPossible` accordingly.

---

## Dashboard Integration

The project's `status.html` dashboard reads `achievements.json` and displays:

- Total points earned vs possible
- Progress bar (earned / possible as percentage)
- Count of unlocked vs total achievements
- 5 most recently unlocked achievements (sorted by `unlockedAt` descending)
- Reload button to re-fetch data without page refresh

This provides an at-a-glance view of player progress alongside development status.

---

## File Dependency Map

```
achievements.json          ← Single source of truth
  ├── status.html          ← Dashboard reads for display
  ├── AchievementManager   ← Runtime autoload (future, reads/writes)
  ├── AchievementMenu      ← UI panel (future, reads for display)
  └── AchievementToast     ← Overlay popup (future, triggered by signal)
```
