# Test Plan — Final Fantasy 3D

## How to Test
No automated test framework is currently configured. All testing is manual via the Godot editor.

**Launch:** Open `project.godot` in Godot 4.4+, press F5 (or Play). Main menu loads first.
**Test Arena:** Main Menu → Start → loads `src/world/test_arena.tscn`

---

## Core Systems Checklist

### Player Movement
- [ ] WASD movement in 8 directions
- [ ] Left stick movement with analog sensitivity
- [ ] Sprint (Ctrl / L3) increases speed
- [ ] Jump (Space / A) with gravity and landing
- [ ] Dodge (Shift / B) with i-frames
- [ ] Movement relative to camera facing direction

### Combat
- [ ] Light attack combo (3 hits) via LMB / X
- [ ] Heavy finisher after combo via RMB / Y
- [ ] Combo resets after timeout
- [ ] Attacks connect with test dummies (hitbox/hurtbox)
- [ ] Damage numbers reflected in enemy health
- [ ] Player flinches when hit by enemy
- [ ] I-frames during dodge prevent damage

### Lock-On System
- [ ] Toggle lock-on via MMB / Tab / R3
- [ ] Lock-on reticle appears on target
- [ ] Player faces locked target during strafe
- [ ] Switch targets via Q/E / Right Stick
- [ ] Lock-on breaks at max range
- [ ] Lock-on lost when target dies

### Abilities
- [ ] Abilities 1-6 (keys 1-6 / D-Pad+RB) cast correctly
- [ ] MP consumed on cast
- [ ] Cast fails with flash when insufficient MP
- [ ] Cooldown timers display on ability bar
- [ ] Fire Bolt: projectile spawns and travels forward
- [ ] Ice Arc: AoE damage around caster
- [ ] Lightning Thrust: dash forward with damage
- [ ] Rising Blade: upward dash with AoE
- [ ] Wind Step: long dash with light damage
- [ ] Guardian Rune: shield buff activates

### Tactical Mode
- [ ] T / LB activates slow-time
- [ ] UI overlay appears with ability cards
- [ ] Ability selection via cards works
- [ ] Time returns to normal on exit
- [ ] Can cast abilities from tactical mode

### Camera
- [ ] Isometric orthogonal view follows player
- [ ] Z/X rotates camera 90 degrees
- [ ] Camera rotation is smooth (tweened)
- [ ] Camera properly frames combat

### UI / Menus
- [ ] Health bar tracks player HP
- [ ] MP bar tracks player MP with regen
- [ ] Ability bar shows cooldown overlays
- [ ] MP fail indicator flashes on failed cast
- [ ] Pause menu (Esc / Start) pauses game
- [ ] Options menu accessible from pause
- [ ] Main menu Start/Quit buttons work
- [ ] Controller navigation works in all menus

### VFX
- [ ] Slash arc on melee attacks
- [ ] Hit spark on damage dealt
- [ ] Dodge trail during dodge
- [ ] Fire burst on fire bolt impact
- [ ] Ice burst on ice arc cast
- [ ] Lightning flash on lightning thrust
- [ ] Wind swoosh on wind step
- [ ] Rune shield on guardian rune
- [ ] All VFX auto-cleanup (no orphaned particles)

---

## Known Gaps (Not Bugs)
- No audio — AudioManager stubs present, awaiting assets
- No animations — AnimationPlayer stubs defined, no keyframe data
- No 3D models — all geometry is placeholder primitives
- No textures — flat color materials only
- Enemy AI is passive (test dummies only)

## Regression Watchlist
- Collision layer assignments (8-layer system is fragile)
- State machine transitions (ensure no stuck states)
- Ability cooldown timing accuracy at slow time_scale
- MP regen interaction with tactical mode time_scale
