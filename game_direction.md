# Game Direction — Final Fantasy 3D

## Vision
A Korean medieval fantasy hybrid action RPG with fluid combat, tactical ability usage,
and an isometric perspective that blends classic ARPG aesthetics with modern action mechanics.

## Completed (Phase 1 — Prototype)
- [x] Player controller with full state machine (idle, run, sprint, jump, fall, land, dodge, flinch)
- [x] 3-hit combo chain + heavy finisher attack system
- [x] 6 unique abilities (fire bolt, ice arc, lightning thrust, rising blade, wind step, guardian rune)
- [x] Ability framework: AbilityData resources, AbilityCaster, effect scenes, projectile system
- [x] Lock-on targeting with target switching
- [x] Tactical mode (slow-time ability selection)
- [x] Component architecture (Stats, Combat, Hitbox/Hurtbox, MpRegen, LockOn)
- [x] Event bus architecture (Events autoload)
- [x] HUD: health bar, MP bar, ability bar with cooldowns, lock-on reticle, MP fail indicator
- [x] Menus: main menu, pause menu, options menu
- [x] Camera rig: isometric orthogonal with 90-degree snap rotation
- [x] VFX: 8 GPU particle effect scenes
- [x] Test arena with enemy test dummies
- [x] Controller + keyboard/mouse input bindings

## Next Milestones (Phase 2 — Polish & Content)
- [ ] Audio: SFX for combat, abilities, UI; music tracks
- [ ] 3D Models: player character, enemies, environment props
- [ ] Animations: skeletal animations for all player states
- [ ] Textures: materials, UI art, VFX textures
- [ ] Enemy AI: patrol, chase, attack, stagger behaviors
- [ ] Additional enemy types beyond test dummy
- [ ] Level design: first real environment beyond test arena
- [ ] Save/load system
- [ ] Damage numbers / floating combat text

## Phase 3 — Content & Systems
- [ ] Inventory / equipment system
- [ ] Dialogue / NPC system
- [ ] Quest framework
- [ ] Multiple zones / level transitions
- [ ] Boss encounters
- [ ] Skill tree / character progression
- [ ] Advanced VFX polish (trails, screen shake, hit stop)

## Design Pillars
1. **Fluid Combat** — Responsive controls, tight hit windows, satisfying combos
2. **Tactical Depth** — Slow-time mode adds strategy layer to action combat
3. **Korean Fantasy Aesthetic** — Hanbok-inspired armor, traditional architecture, mythological creatures
4. **Controller-First** — Designed for gamepad with full keyboard/mouse fallback
