extends State

func enter(_prev_state: StringName) -> void:
	player.animation_player.play("jump")
	var jump_force: float = player.stats_data.jump_force if player.stats_data else 10.0
	player.velocity.y = jump_force

func process_physics(delta: float) -> StringName:
	player.apply_gravity(delta)

	# Allow air movement
	var direction := player.get_movement_input()
	if direction.length() > 0.1:
		var speed: float = player.stats_data.move_speed if player.stats_data else 7.0
		player.velocity.x = direction.x * speed * 0.8
		player.velocity.z = direction.z * speed * 0.8
		player.face_direction(direction, delta)

	player.move_and_slide()

	if player.velocity.y <= 0.0:
		return &"Fall"
	return &""
