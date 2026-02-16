extends State

func enter(_prev_state: StringName) -> void:
	player.animation_player.play("lock_on_idle")

func process_physics(delta: float) -> StringName:
	player.apply_gravity(delta)
	player.velocity.x = move_toward(player.velocity.x, 0.0, 20.0 * delta)
	player.velocity.z = move_toward(player.velocity.z, 0.0, 20.0 * delta)
	player.move_and_slide()

	if not player.is_locked_on:
		return &"Idle"

	player.face_target(delta)

	var input_dir := player.get_movement_input()
	if input_dir.length() > 0.1:
		return &"LockOnStrafe"

	if not player.is_on_floor():
		return &"Fall"
	return &""

func process_input(event: InputEvent) -> StringName:
	if event.is_action_pressed(&"lock_on_toggle"):
		player.lock_on_component.release_target()
		return &"Idle"
	if event.is_action_pressed(&"lock_on_switch_left"):
		player.lock_on_component.switch_target(-1)
	if event.is_action_pressed(&"lock_on_switch_right"):
		player.lock_on_component.switch_target(1)
	if event.is_action_pressed(&"jump"):
		return &"Jump"
	if event.is_action_pressed(&"dodge") and player.dodge_ready:
		return &"Dodge"
	if event.is_action_pressed(&"attack"):
		return &"Attack1"
	if event.is_action_pressed(&"tactical_mode"):
		if GameManager.current_state == GameManager.GameState.PLAYING:
			GameManager.change_state(GameManager.GameState.TACTICAL_MODE)
	for i in range(6):
		var action := &"ability_%d" % (i + 1)
		if event.is_action_pressed(action):
			if player.ability_caster.try_cast(i):
				return &"Ability"
	return &""
