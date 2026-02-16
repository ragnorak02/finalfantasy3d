extends State

var flinch_timer: float = 0.0
const FLINCH_DURATION := 0.4

func enter(_prev_state: StringName) -> void:
	flinch_timer = 0.0
	player.animation_player.play("flinch")
	player.velocity = Vector3.ZERO

func process_physics(delta: float) -> StringName:
	flinch_timer += delta
	player.apply_gravity(delta)
	player.move_and_slide()

	if flinch_timer >= FLINCH_DURATION:
		return &"LockOnIdle" if player.is_locked_on else &"Idle"
	return &""
