extends AbilityEffectBase

func _do_effect() -> void:
	var direction := caster.get_movement_input()
	if direction.length() < 0.1:
		direction = -caster.player_model.basis.z.normalized()
	direction.y = 0.0
	direction = direction.normalized()

	var dist := ability_data.movement_distance if ability_data else 8.0
	var vfx := preload("res://src/vfx/wind_swoosh.tscn").instantiate()
	get_tree().current_scene.add_child(vfx)
	vfx.global_position = caster.global_position + Vector3.UP
	var tween := create_tween()
	tween.tween_property(caster, "global_position",
		caster.global_position + direction * dist, 0.25).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	caster.hurtbox_component.set_invulnerable(true)
	await tween.finished
	caster.hurtbox_component.set_invulnerable(false)
	_finish()
