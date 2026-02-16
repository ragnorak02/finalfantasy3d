extends Node

# Player Stats
signal player_hp_changed(current: float, max_hp: float)
signal player_mp_changed(current: float, max_mp: float)
signal player_died()

# Combat
signal damage_dealt(target: Node3D, amount: float, source: Node3D)
signal damage_received(target: Node3D, amount: float, source: Node3D)
signal combo_count_changed(count: int)
signal combo_reset()

# Abilities
signal ability_cast_started(ability_data: Resource)
signal ability_cast_completed(ability_data: Resource)
signal ability_cast_failed_no_mp(ability_data: Resource)
signal ability_cooldown_started(index: int, duration: float)
signal ability_cooldown_finished(index: int)

# Lock-On
signal lock_on_target_acquired(target: Node3D)
signal lock_on_target_switched(new_target: Node3D)
signal lock_on_target_lost()

# State
signal player_state_changed(old_state: StringName, new_state: StringName)

# Game State
signal tactical_mode_entered()
signal tactical_mode_exited()
signal game_paused()
signal game_resumed()

# UI
signal ability_selected_from_tactical(index: int)
signal mp_fail_flash_requested()

# Camera
signal camera_shake_requested(intensity: float, duration: float)
signal camera_snap_rotation_requested(direction: int)
