extends State

var dodge_timer: float = 0.0
var dodge_direction: Vector3 = Vector3.ZERO

func enter(_prev_state: StringName) -> void:
	player.animation_player.play("dodge")
	dodge_timer = 0.0

	# Dodge in input direction, or backward if no input
	var input_dir := player.get_movement_input()
	if input_dir.length() > 0.1:
		dodge_direction = input_dir.normalized()
	else:
		dodge_direction = -player.facing_direction

	player.start_dodge_cooldown()

	# Spawn dodge trail VFX
	var trail: Node3D = preload("res://src/vfx/dodge_trail.tscn").instantiate()
	player.get_tree().current_scene.add_child(trail)
	trail.global_position = player.global_position + Vector3.UP

	# Enable i-frames
	var iframe_start: float = player.stats_data.dodge_iframe_start if player.stats_data else 0.05
	if iframe_start <= 0.0:
		player.hurtbox_component.set_invulnerable(true)

func exit(_next_state: StringName) -> void:
	player.hurtbox_component.set_invulnerable(false)

func process_physics(delta: float) -> StringName:
	dodge_timer += delta

	var duration: float = player.stats_data.dodge_duration if player.stats_data else 0.4
	var speed: float = player.stats_data.dodge_speed if player.stats_data else 15.0
	var iframe_start: float = player.stats_data.dodge_iframe_start if player.stats_data else 0.05
	var iframe_end: float = player.stats_data.dodge_iframe_end if player.stats_data else 0.3

	# I-frame window
	if dodge_timer >= iframe_start and dodge_timer <= iframe_end:
		player.hurtbox_component.set_invulnerable(true)
	else:
		player.hurtbox_component.set_invulnerable(false)

	# Apply dodge velocity with decay
	var progress := dodge_timer / duration
	var speed_mult := 1.0 - (progress * progress)
	player.velocity.x = dodge_direction.x * speed * speed_mult
	player.velocity.z = dodge_direction.z * speed * speed_mult
	player.apply_gravity(delta)
	player.move_and_slide()

	if dodge_timer >= duration:
		if player.is_locked_on:
			return &"LockOnIdle"
		return &"Idle"
	return &""
