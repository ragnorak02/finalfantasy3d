class_name AbilityEffectBase extends Node3D

var caster: CharacterBody3D
var target: Node3D
var ability_data: AbilityData

func execute(p_caster: CharacterBody3D, p_target: Node3D, p_data: AbilityData) -> void:
	caster = p_caster
	target = p_target
	ability_data = p_data
	global_position = caster.global_position
	_do_effect()

func _do_effect() -> void:
	pass

func _finish() -> void:
	queue_free()
