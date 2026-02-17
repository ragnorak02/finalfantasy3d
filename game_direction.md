# Game Direction — Final Fantasy 3D

## Vision
A Korean medieval fantasy hybrid action RPG with fluid combat, tactical ability usage,
and an isometric perspective that blends classic ARPG aesthetics with modern action mechanics.

## Design Pillars
1. **Fluid Combat** — Responsive controls, tight hit windows, satisfying combos
2. **Tactical Depth** — Slow-time mode adds strategy layer to action combat
3. **Korean Fantasy Aesthetic** — Hanbok-inspired armor, traditional architecture, mythological creatures
4. **Controller-First** — Designed for gamepad with full keyboard/mouse fallback

---

## Completed (Phase 1 — Prototype)
- [x] Player controller with full state machine (15 states: idle, run, sprint, jump, fall, land, dodge, flinch, attack, heavy attack, ability cast, tactical, death, etc.)
- [x] 3-hit combo chain + heavy finisher attack system
- [x] 6 unique abilities (Fire Bolt, Ice Arc, Lightning Thrust, Rising Blade, Wind Step, Guardian Rune)
- [x] Ability framework: AbilityData resources, AbilityCaster, effect scenes, projectile system
- [x] Lock-on targeting with target switching
- [x] Tactical mode (slow-time ability selection via Engine.time_scale)
- [x] Component architecture (Stats, Combat, Hitbox/Hurtbox, MpRegen, LockOn)
- [x] Event bus architecture (Events autoload)
- [x] HUD: health bar, MP bar, ability bar with cooldowns, lock-on reticle, MP fail indicator
- [x] Menus: main menu, pause menu, options menu
- [x] Camera rig: isometric orthogonal with 90-degree snap rotation
- [x] VFX: 8 GPU particle effect scenes
- [x] Test arena with 3 enemy test dummies
- [x] Controller + keyboard/mouse input bindings (22 actions)
- [x] Achievement system infrastructure (20 achievements, 285 pts)
- [x] Debug overlay + controls overlay HUD
- [x] Studio OS integration (game.config.json + 25-test automated test runner)

**Phase 1 Stats:** 61 scripts, 36 scenes, 9 resources, 3 shaders

---

## Next Milestones (Phase 2 — Polish & Content)

### 2A: Combat Feel (High Priority)
- [ ] **Hit stop / freeze frames** — 50-80ms pause on heavy attacks and ability hits for impact
- [ ] **Screen shake** — Camera shake on impactful abilities (rising blade, lightning thrust)
- [ ] **Damage numbers** — Floating combat text with crit scaling and element colors
- [ ] **Hit flash** — Brief white flash on damaged enemies
- [ ] **Combo counter UI** — Visible combo count with grade system (D/C/B/A/S)

### 2B: Audio (High Priority)
- [ ] SFX: sword swings (3 variants), impacts, dodge whoosh, ability cast sounds
- [ ] SFX: UI navigation, menu select, ability cooldown ready
- [ ] SFX: enemy hit reactions, death sounds
- [ ] Music: main menu theme, arena combat loop, tactical mode ambient
- [ ] AudioManager: connect existing stub callbacks to real audio streams

### 2C: Animation & Models (High Priority)
- [ ] Player character 3D model (replace capsule placeholder)
- [ ] Skeletal animations for all 15 player states
- [ ] Enemy models (at least 3 types: melee grunt, ranged caster, heavy brute)
- [ ] Animation blending and transition polish
- [ ] Root motion vs. code-driven movement decision

### 2D: Enemy AI (Medium Priority)
- [ ] State machine for enemies (idle, patrol, chase, attack, stagger, death)
- [ ] Aggro detection radius with sight/sound
- [ ] Attack patterns: melee swing, ranged projectile, charge attack
- [ ] Stagger system — enemies flinch on hit, stun on combo threshold
- [ ] Enemy spawn system for wave-based encounters

### 2E: Environment & Levels (Medium Priority)
- [ ] First real level environment (Korean temple courtyard or mountain path)
- [ ] Environmental props (lanterns, barriers, destructibles)
- [ ] Textures and materials for ground, walls, props
- [ ] Lighting setup: directional sun + ambient + point lights for atmosphere
- [ ] Level transition / door system

### 2F: Systems (Lower Priority)
- [ ] Save/load system (player stats, position, unlocked abilities)
- [ ] Achievement unlock hooks in gameplay code
- [ ] Settings persistence (audio volume, controls, display)

---

## Phase 3 — Content & Systems
- [ ] **Inventory / Equipment** — Weapon types (sword, spear, staff) with different combo chains
- [ ] **Skill tree** — Each ability has 3 evolution paths (power/range/utility)
- [ ] **Elemental system** — Status effects: burn (DoT), freeze (slow), shock (stun), wind (knockback)
- [ ] **Ability combos** — Chain abilities for bonus effects (fire + wind = fire tornado)
- [ ] **Dialogue / NPC system** — Story NPCs with branching dialogue
- [ ] **Quest framework** — Main story + side quests with objective tracking
- [ ] **Multiple zones** — Village hub, forest, temple dungeon, mountain peak
- [ ] **Boss encounters** — Unique bosses with multi-phase patterns
- [ ] **Parry / perfect guard** — Timing-based defense mechanic with counter-attack window
- [ ] **Advanced VFX** — Trails, afterimages, elemental auras, environmental particles

---

## Gameplay Improvement Suggestions

### Combat Depth
1. **Dodge cancel windows** — Allow dodging out of attack recovery frames for more responsive combat flow. Currently attacks lock the player in until the animation completes.
2. **Juggle system** — Add launcher attacks that pop enemies airborne, enabling air combos. Rising Blade is a natural fit for this.
3. **Parry mechanic** — Add a timed guard (tap dodge just before impact) that rewards precision with a counter-attack window and bonus damage.
4. **Weapon switching** — Mid-combat weapon swap (e.g., sword/spear/staff) each with unique combo chains and ability synergies.
5. **Charged attacks** — Hold heavy attack to charge for increased damage/range/AoE. Visual feedback with growing particle effect.

### Tactical Mode Enhancement
1. **Ability synergies** — Show combo potential in tactical UI (e.g., "Fire Bolt + Wind Step = Fire Dash"). Reward players for creative ability chaining.
2. **Target priority overlay** — Highlight weakest enemies, show HP bars, display elemental weaknesses during tactical pause.
3. **Queue system** — Queue 2-3 abilities in tactical mode that execute in sequence when unpaused.

### Progression & Replayability
1. **Arena challenge modes** — Timed survival waves, no-damage runs, ability-restricted challenges with leaderboard scores.
2. **Training room** — Dedicated space with DPS dummy, combo counter, hitbox visualization, and move list.
3. **Ability mastery** — Track per-ability usage. Unlock alternate versions after enough uses (Fire Bolt > Fire Barrage after 100 casts).
4. **New Game+** — Carry over abilities and upgrades with scaled enemy difficulty.

### Game Feel & Polish
1. **Controller rumble** — Haptic feedback on hits, ability impacts, and low HP warning.
2. **Slow-motion on kill** — Brief 200ms slowdown when defeating the last enemy in an encounter.
3. **Dynamic music** — Combat music intensity scales with combo count and remaining enemies.
4. **Environmental interaction** — Destructible objects, ability-triggered shortcuts (burn vines, freeze water, shock mechanisms).

### Content Ideas
1. **Rival system** — Recurring enemy that mirrors player abilities, appears at story beats.
2. **Mythological bestiary** — Korean folklore creatures (Dokkaebi goblins, Gumiho fox spirits, Haetae guardians).
3. **Seasonal events** — Chuseok harvest festival, Lunar New Year challenges with themed rewards.
4. **Companion summons** — Tactical mode summon that fights alongside player for limited duration.

---

## Technical Debt & Cleanup
- [ ] AnimationPlayer has 16 stubs with no keyframe data — needs real animations or removal
- [ ] AudioManager callbacks are all `pass` — wire to real audio or add placeholder beeps
- [ ] Consider migrating from Godot 4.4 to 4.6 officially (already running on 4.6 binary)
- [ ] Profile scene loading performance — 8 critical scenes should load under 2 seconds
- [ ] Add input rebinding UI in options menu
