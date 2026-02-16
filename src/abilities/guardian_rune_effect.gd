extends AbilityEffectBase

var _vfx_instance: Node3D

func _do_effect() -> void:
	caster.hurtbox_component.set_invulnerable(true)
	_vfx_instance = preload("res://src/vfx/rune_shield.tscn").instantiate()
	caster.add_child(_vfx_instance)
	_vfx_instance.position = Vector3.UP
	var duration := ability_data.cc_duration if ability_data else 3.0
	await get_tree().create_timer(duration).timeout
	if is_instance_valid(_vfx_instance):
		_vfx_instance.queue_free()
	if is_instance_valid(caster):
		caster.hurtbox_component.set_invulnerable(false)
	_finish()
