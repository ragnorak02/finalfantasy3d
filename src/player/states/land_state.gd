extends State

var land_timer: float = 0.0
const LAND_DURATION := 0.15

func enter(_prev_state: StringName) -> void:
	player.animation_player.play("land")
	land_timer = 0.0
	player.velocity.x = 0.0
	player.velocity.z = 0.0

func process_physics(delta: float) -> StringName:
	player.apply_gravity(delta)
	player.move_and_slide()
	land_timer += delta

	if land_timer >= LAND_DURATION:
		var input_dir := player.get_movement_input()
		if input_dir.length() > 0.1:
			return &"Run"
		return &"Idle"
	return &""
