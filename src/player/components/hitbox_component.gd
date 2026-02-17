class_name HitboxComponent extends Area3D

var damage: float = 0.0
var source: Node3D = null
var _hit_targets: Array[Node3D] = []

func activate(dmg: float, dmg_source: Node3D) -> void:
	damage = dmg
	source = dmg_source
	_hit_targets.clear()
	monitoring = true

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
		Events.camera_shake_requested.emit(0.15, 0.2)
		var vfx: Node3D = preload("res://src/vfx/hit_spark.tscn").instantiate()
		get_tree().current_scene.add_child(vfx)
		vfx.global_position = area.global_position
