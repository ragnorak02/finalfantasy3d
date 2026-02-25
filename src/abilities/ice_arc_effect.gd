extends AbilityEffectBase

func _do_effect() -> void:
	var forward: Vector3 = caster.player_model.basis.z.normalized()
	var cone_angle := 60.0
	var range_val := ability_data.aoe_radius if ability_data else 4.0
	var enemies := get_tree().get_nodes_in_group(&"enemies")
	for enemy in enemies:
		if enemy is Node3D:
			var to_enemy: Vector3 = (enemy.global_position - caster.global_position)
			to_enemy.y = 0.0
			var dist: float = to_enemy.length()
			if dist > range_val or dist < 0.1:
				continue
			var angle := rad_to_deg(forward.angle_to(to_enemy.normalized()))
			if angle <= cone_angle:
				if enemy.has_method("take_damage"):
					var dmg := ability_data.damage if ability_data else 15.0
					enemy.take_damage(dmg, caster)
					Events.damage_dealt.emit(enemy, dmg, caster)
					Events.hit_stop_requested.emit(0.05)
					Events.camera_shake_requested.emit(0.15, 0.2)
					var dmg_num := preload("res://src/ui/floating_damage_number.tscn").instantiate()
					get_tree().current_scene.add_child(dmg_num)
					dmg_num.global_position = enemy.global_position + Vector3.UP * 0.5
					dmg_num.setup(dmg)
	var vfx := preload("res://src/vfx/ice_burst.tscn").instantiate()
	get_tree().current_scene.add_child(vfx)
	vfx.global_position = caster.global_position + Vector3.UP + (caster.player_model.basis.z.normalized() * 2.0)
	await get_tree().create_timer(0.4).timeout
	_finish()
