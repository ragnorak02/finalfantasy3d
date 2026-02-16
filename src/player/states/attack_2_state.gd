extends State

var attack_timer: float = 0.0
var attack_data: AttackMoveData
var combo_window_open: bool = false
var buffered_next: StringName = &""

func enter(_prev_state: StringName) -> void:
	attack_timer = 0.0
	combo_window_open = false
	buffered_next = &""
	attack_data = player.combat_component.get_current_attack()
	player.animation_player.play("attack_2")
	if player.is_locked_on:
		player.face_target(0.1)

func exit(_next_state: StringName) -> void:
	player.hitbox_pivot.get_node("HitboxComponent").deactivate()

func process_physics(delta: float) -> StringName:
	attack_timer += delta
	player.apply_gravity(delta)

	if attack_data and attack_timer < 0.3:
		var forward := -player.player_model.basis.z.normalized()
		player.velocity.x = forward.x * attack_data.forward_movement * 5.0
		player.velocity.z = forward.z * attack_data.forward_movement * 5.0
	else:
		player.velocity.x = move_toward(player.velocity.x, 0.0, 30.0 * delta)
		player.velocity.z = move_toward(player.velocity.z, 0.0, 30.0 * delta)

	player.move_and_slide()

	if attack_data:
		var hitbox: Area3D = player.hitbox_pivot.get_node("HitboxComponent")
		if attack_timer >= attack_data.hitbox_activation_time and attack_timer < attack_data.hitbox_deactivation_time:
			if not hitbox.monitoring:
				var base_dmg: float = player.stats_data.attack_base_damage if player.stats_data else 10.0
				hitbox.activate(player.combat_component.calculate_damage(base_dmg, attack_data.damage_multiplier), player)
		elif attack_timer >= attack_data.hitbox_deactivation_time:
			hitbox.deactivate()

		if attack_timer >= attack_data.combo_window_start and attack_timer <= attack_data.combo_window_end:
			combo_window_open = true
		elif attack_timer > attack_data.combo_window_end:
			combo_window_open = false
			if buffered_next != &"":
				return buffered_next

	if not player.animation_player.is_playing() or attack_timer > 0.6:
		player.combat_component.reset_combo()
		return &"LockOnIdle" if player.is_locked_on else &"Idle"

	return &""

func process_input(event: InputEvent) -> StringName:
	if event.is_action_pressed(&"dodge") and player.dodge_ready:
		return &"Dodge"
	if event.is_action_pressed(&"attack"):
		if combo_window_open:
			player.combat_component.advance_combo()
			return &"Attack3"
		else:
			buffered_next = &"Attack3"
	if event.is_action_pressed(&"heavy_attack"):
		if combo_window_open:
			return &"HeavyFinisher"
		else:
			buffered_next = &"HeavyFinisher"
	return &""
