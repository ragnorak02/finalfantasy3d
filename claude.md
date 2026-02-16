# Korean Fantasy RPG - Claude Project Intelligence

## Project Overview
Korean medieval fantasy hybrid action RPG built in Godot 4.4 with GDScript.
Semi-fixed isometric camera, orthogonal projection, 90-degree snap rotation.
Controller-first input with keyboard/mouse support.

## Architecture

### Autoloads (load order matters)
1. **Events** — Global signal bus (`src/autoloads/events.gd`)
2. **GameManager** — Game state, pause, scene transitions (`src/autoloads/game_manager.gd`)
3. **InputManager** — Input abstraction, buffer system (`src/autoloads/input_manager.gd`)
4. **AudioManager** — SFX pool + music crossfade (`src/autoloads/audio_manager.gd`)

### State Machine
- Flat node-based: states are child Nodes of `StateMachine`
- States return `StringName` for transitions (empty = no transition)
- Base class: `State` (`src/player/states/state.gd`)
- Machine: `StateMachine` (`src/player/states/state_machine.gd`)

### Components (Node-based)
- `StatsComponent` — HP/MP tracking, damage application
- `CombatComponent` — Combo tracking, attack chaining
- `AbilityCaster` — Ability execution, cooldowns, MP checks
- `LockOnComponent` — Target acquisition/switching (Area3D detection)
- `HitboxComponent` / `HurtboxComponent` — Damage dealing/receiving
- `MpRegenComponent` — Passive MP regeneration

### Collision Layers (Godot 1-indexed)
| Layer | Bit | Name |
|-------|-----|------|
| 1 | 1 | World |
| 2 | 2 | PlayerBody |
| 3 | 4 | EnemyBody |
| 4 | 8 | PlayerHitbox |
| 5 | 16 | EnemyHitbox |
| 6 | 32 | PlayerHurtbox |
| 7 | 64 | EnemyHurtbox |
| 8 | 128 | LockOnDetection |

### Tactical Mode
- Uses `Engine.time_scale = 0.1` (NOT tree pause)
- UI nodes use `process_mode = ALWAYS` to remain responsive
- Ability selection via radial/card UI

## Key Patterns
- Player abilities loaded in `player.gd:_load_abilities()` from `data/abilities/*.tres`
- AbilityData resources reference `effect_scene` (`.tscn` wrappers around effect scripts)
- Hurtbox uses `is_invulnerable` flag (not monitoring toggle) for i-frames
- VFX scenes auto-free via Timer nodes (AutoFree pattern)
- All event communication goes through the `Events` autoload signal bus

## File Structure
```
src/
  autoloads/          # Global singletons
  player/
    components/       # Node-based components
    states/           # State machine states
    player.gd/.tscn   # Player controller + scene
  enemies/
    enemy_base.*      # Base enemy class
    test_dummy/       # Test target enemy
  camera/             # Isometric camera rig
  abilities/
    projectiles/      # Projectile base + variants
    *_effect.*        # Ability effect scripts + scenes
  ui/
    hud/              # In-game HUD elements
    menus/            # Main/Pause/Options menus
    tactical/         # Tactical mode UI
  vfx/                # Particle effect scenes
  world/              # Level scenes
data/
  abilities/          # AbilityData .tres resources
assets/
  shaders/            # Visual shaders
  audio/              # (empty — awaiting assets)
  models/             # (empty — awaiting assets)
  textures/           # (empty — awaiting assets)
  animations/         # (empty — awaiting assets)
resources/            # Custom Resource class definitions
```

## Input Bindings
| Action | Keyboard | Controller |
|--------|----------|------------|
| Move | WASD | Left Stick |
| Jump | Space | A (South) |
| Dodge | Shift | B (East) |
| Sprint | Ctrl | L3 |
| Attack | LMB | X (West) |
| Heavy Attack | RMB | Y (North) |
| Lock-On | MMB / Tab | R3 |
| Lock Switch | Q/E | Right Stick X |
| Tactical Mode | T | LB |
| Abilities 1-6 | 1-6 | D-Pad + RB |
| Camera Rotate | Z/X | — |
| Pause | Escape | Start |

## Current Repo State (Auto-Detected)
- Phase 1 prototype is **functionally complete** — all core systems wired and running
- All 3D geometry uses **placeholder primitives** (CapsuleMesh, BoxMesh, PlaneMesh)
- **Zero audio assets** — `assets/audio/sfx/` and `assets/audio/music/` directories are empty
- **Zero textures/images** — all materials use flat `albedo_color` values
- **Zero 3D models** — `assets/models/` directories are empty
- AnimationPlayer has **16 animation stubs defined** but no keyframe data
- AudioManager has **stub callbacks** (`pass`) for hit sounds, fail buzzer, dodge whoosh
- `State` base class `enter()`/`exit()` are intentional abstract stubs (override pattern)
- `AbilityEffectBase._do_effect()` is intentional abstract stub (override pattern)
- 6 abilities fully configured in `data/abilities/*.tres` with effect scenes
- Test arena is a complete playable scene with 3 test dummies

## Achievement System
- **Data file:** `/achievements.json` — single source of truth (20 achievements, 285 pts)
- **Integration guide:** `/achievements_integration.md` — menu contract, toast spec, unlock flow
- **Dashboard:** `status.html` loads achievements.json and displays progress
- **Rules:** Append-only, never reset unlocked state, always recalculate totals
- **Future signal:** `Events.achievement_unlocked(achievement_id: String)`

## Conventions
- GDScript style: snake_case functions/variables, PascalCase classes, UPPER_CASE constants
- Signals defined centrally in `Events` autoload, not per-node
- Scenes and scripts are co-located (`thing.gd` + `thing.tscn` in same directory)
- Resources defined in `/resources/`, instances in `/data/`
- No `@onready` chains — use explicit `get_node()` in `_ready()` or `@onready` single-line
