class_name HitboxComponent extends Area3D

var damage: float = 0.0
var source: Node3D = null
var _hit_targets: Array[Node3D] = []

var hit_stop_duration: float = 0.065
var shake_intensity: float = 0.15
var shake_duration: float = 0.2

func activate(dmg: float, dmg_source: Node3D, p_hit_stop: float = 0.065, p_shake_intensity: float = 0.15, p_shake_duration: float = 0.2) -> void:
	damage = dmg
	source = dmg_source
	hit_stop_duration = p_hit_stop
	shake_intensity = p_shake_intensity
	shake_duration = p_shake_duration
	_hit_targets.clear()
	monitoring = true
	# Spawn slash arc VFX at hitbox position
	var vfx: Node3D = preload("res://src/vfx/slash_arc.tscn").instantiate()
	get_tree().current_scene.add_child(vfx)
	vfx.global_position = global_position

func deactivate() -> void:
	monitoring = false
	damage = 0.0
	_hit_targets.clear()

func _ready() -> void:
	monitoring = false
	area_entered.connect(_on_area_entered)

func _on_area_entered(area: Area3D) -> void:
	if area is HurtboxComponent:
		var target_root := area.get_parent()
		if target_root == source:
			return
		if target_root in _hit_targets:
			return
		_hit_targets.append(target_root)
		area.receive_hit(self)
		Events.damage_dealt.emit(target_root, damage, source)
		Events.hit_stop_requested.emit(hit_stop_duration)
		Events.camera_shake_requested.emit(shake_intensity, shake_duration)
		var vfx: Node3D = preload("res://src/vfx/hit_spark.tscn").instantiate()
		get_tree().current_scene.add_child(vfx)
		vfx.global_position = area.global_position
		var dmg_num := preload("res://src/ui/floating_damage_number.tscn").instantiate()
		get_tree().current_scene.add_child(dmg_num)
		dmg_num.global_position = area.global_position + Vector3.UP * 0.5
		dmg_num.setup(damage)
