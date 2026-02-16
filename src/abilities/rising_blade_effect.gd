extends AbilityEffectBase

func _do_effect() -> void:
	if target and is_instance_valid(target):
		var dir := (target.global_position - caster.global_position).normalized()
		dir.y = 0.0
		var dist := caster.global_position.distance_to(target.global_position)
		var dash_dist := minf(dist - 1.5, ability_data.movement_distance if ability_data else 5.0)
		if dash_dist > 0.0:
			var tween := create_tween()
			tween.tween_property(caster, "global_position",
				caster.global_position + dir * dash_dist, 0.2).set_ease(Tween.EASE_OUT)
			await tween.finished
	_apply_aoe_damage()
	var vfx := preload("res://src/vfx/slash_arc.tscn").instantiate()
	get_tree().current_scene.add_child(vfx)
	vfx.global_position = caster.global_position + Vector3.UP
	await get_tree().create_timer(0.3).timeout
	_finish()

func _apply_aoe_damage() -> void:
	var radius := ability_data.aoe_radius if ability_data else 3.0
	var enemies := get_tree().get_nodes_in_group(&"enemies")
	for enemy in enemies:
		if enemy is Node3D:
			var dist := caster.global_position.distance_to(enemy.global_position)
			if dist <= radius and enemy.has_method("take_damage"):
				var dmg := ability_data.damage if ability_data else 25.0
				enemy.take_damage(dmg, caster)
				Events.damage_dealt.emit(enemy, dmg, caster)
