extends AbilityEffectBase

func _do_effect() -> void:
	var direction: Vector3
	if target and is_instance_valid(target):
		direction = (target.global_position - caster.global_position).normalized()
	else:
		direction = caster.player_model.basis.z.normalized()
	direction.y = 0.0
	direction = direction.normalized()

	var dist := ability_data.movement_distance if ability_data else 4.0
	var tween := create_tween()
	tween.tween_property(caster, "global_position",
		caster.global_position + direction * dist, 0.15).set_ease(Tween.EASE_IN)
	await tween.finished
	var vfx := preload("res://src/vfx/lightning_flash.tscn").instantiate()
	get_tree().current_scene.add_child(vfx)
	vfx.global_position = caster.global_position + Vector3.UP
	var enemies := get_tree().get_nodes_in_group(&"enemies")
	var hit_range := 2.5
	for enemy in enemies:
		if enemy is Node3D:
			var d := caster.global_position.distance_to(enemy.global_position)
			if d <= hit_range and enemy.has_method("take_damage"):
				var dmg := ability_data.damage if ability_data else 35.0
				enemy.take_damage(dmg, caster)
				Events.damage_dealt.emit(enemy, dmg, caster)
				Events.hit_stop_requested.emit(0.065)
				Events.camera_shake_requested.emit(0.25, 0.3)
				var dmg_num := preload("res://src/ui/floating_damage_number.tscn").instantiate()
				get_tree().current_scene.add_child(dmg_num)
				dmg_num.global_position = enemy.global_position + Vector3.UP * 0.5
				dmg_num.setup(dmg)
	_finish()
