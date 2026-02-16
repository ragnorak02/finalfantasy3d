extends State

func enter(_prev_state: StringName) -> void:
	player.animation_player.play("sprint")

func process_physics(delta: float) -> StringName:
	player.apply_gravity(delta)

	var direction := player.get_movement_input()
	if direction.length() < 0.1:
		return &"Idle"

	if not Input.is_action_pressed(&"sprint"):
		return &"Run"

	var speed: float = player.stats_data.sprint_speed if player.stats_data else 12.0
	player.velocity.x = direction.x * speed
	player.velocity.z = direction.z * speed
	player.face_direction(direction, delta)
	player.move_and_slide()

	if not player.is_on_floor():
		return &"Fall"
	return &""

func process_input(event: InputEvent) -> StringName:
	if event.is_action_pressed(&"jump"):
		return &"Jump"
	if event.is_action_pressed(&"dodge") and player.dodge_ready:
		return &"Dodge"
	if event.is_action_pressed(&"attack"):
		return &"Attack1"
	return &""
