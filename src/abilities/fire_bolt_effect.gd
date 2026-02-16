extends AbilityEffectBase

func _do_effect() -> void:
	var proj_scene := preload("res://src/abilities/projectiles/fire_bolt_projectile.tscn")
	var proj := proj_scene.instantiate()
	get_tree().current_scene.add_child(proj)
	proj.global_position = caster.global_position + Vector3.UP * 1.0

	var direction: Vector3
	if target and is_instance_valid(target):
		direction = (target.global_position + Vector3.UP - proj.global_position).normalized()
	else:
		direction = -caster.player_model.basis.z.normalized()

	proj.launch(direction, ability_data.damage if ability_data else 20.0, caster)
	var vfx := preload("res://src/vfx/fire_burst.tscn").instantiate()
	get_tree().current_scene.add_child(vfx)
	vfx.global_position = caster.global_position + Vector3.UP
	_finish()
