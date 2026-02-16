extends State

var ability_timer: float = 0.0
var current_ability: AbilityData
var effect_instance: Node

func enter(_prev_state: StringName) -> void:
	ability_timer = 0.0
	effect_instance = null
	current_ability = _get_last_cast_ability()
	if current_ability and current_ability.animation_name != &"":
		player.animation_player.play(current_ability.animation_name)
	else:
		player.animation_player.play("ability")

	if player.is_locked_on:
		player.face_target(0.1)
	else:
		var dir := player.get_movement_input()
		if dir.length() > 0.1:
			player.face_direction(dir, 0.1, 100.0)

	if current_ability and current_ability.effect_scene:
		effect_instance = current_ability.effect_scene.instantiate()
		player.get_tree().current_scene.add_child(effect_instance)
		if effect_instance.has_method("execute"):
			effect_instance.execute(player, player.lock_on_target, current_ability)

func exit(_next_state: StringName) -> void:
	if current_ability:
		Events.ability_cast_completed.emit(current_ability)

func process_physics(delta: float) -> StringName:
	ability_timer += delta
	player.apply_gravity(delta)
	player.velocity.x = move_toward(player.velocity.x, 0.0, 20.0 * delta)
	player.velocity.z = move_toward(player.velocity.z, 0.0, 20.0 * delta)
	player.move_and_slide()

	var duration := current_ability.cast_time if current_ability else 0.6
	if duration <= 0.0:
		duration = 0.6
	if ability_timer >= duration:
		return &"LockOnIdle" if player.is_locked_on else &"Idle"
	return &""

func process_input(event: InputEvent) -> StringName:
	if event.is_action_pressed(&"dodge") and player.dodge_ready:
		return &"Dodge"
	return &""

func _get_last_cast_ability() -> AbilityData:
	for i in player.ability_caster.MAX_SLOTS:
		var ability := player.ability_caster.get_ability(i)
		if ability and player.ability_caster.is_on_cooldown(i):
			var remaining := player.ability_caster.get_cooldown_remaining(i)
			if remaining >= ability.cooldown - 0.1:
				return ability
	return null
