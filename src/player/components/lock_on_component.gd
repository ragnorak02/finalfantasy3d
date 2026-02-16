class_name LockOnComponent extends Node

@export var detection_range: float = 20.0
@export var player: CharacterBody3D

var current_target: Node3D = null
var potential_targets: Array[Node3D] = []

func _ready() -> void:
	await get_tree().process_frame
	if player == null:
		player = get_parent().get_parent()

func acquire_target() -> void:
	_scan_targets()
	if potential_targets.is_empty():
		return
	var closest: Node3D = null
	var closest_dist := INF
	for t in potential_targets:
		var dist := player.global_position.distance_to(t.global_position)
		if dist < closest_dist:
			closest_dist = dist
			closest = t
	if closest:
		current_target = closest
		Events.lock_on_target_acquired.emit(current_target)

func release_target() -> void:
	current_target = null
	Events.lock_on_target_lost.emit()

func switch_target(direction: int) -> void:
	if current_target == null:
		return
	_scan_targets()
	if potential_targets.size() <= 1:
		return
	var cam_right := Vector3.RIGHT.rotated(Vector3.UP, player.camera_yaw)
	var targets_with_angle: Array = []
	for t in potential_targets:
		var to_target := (t.global_position - player.global_position).normalized()
		var angle := cam_right.dot(to_target)
		targets_with_angle.append({"target": t, "angle": angle})
	targets_with_angle.sort_custom(func(a, b): return a.angle < b.angle)
	var current_idx := -1
	for i in targets_with_angle.size():
		if targets_with_angle[i].target == current_target:
			current_idx = i
			break
	if current_idx == -1:
		return
	var new_idx := (current_idx + direction) % targets_with_angle.size()
	if new_idx < 0:
		new_idx = targets_with_angle.size() - 1
	current_target = targets_with_angle[new_idx].target
	Events.lock_on_target_switched.emit(current_target)

func _scan_targets() -> void:
	potential_targets.clear()
	var enemies := get_tree().get_nodes_in_group(&"enemies")
	for enemy in enemies:
		if enemy is Node3D:
			var dist := player.global_position.distance_to(enemy.global_position)
			if dist <= detection_range:
				potential_targets.append(enemy)

func _process(_delta: float) -> void:
	if current_target and is_instance_valid(current_target):
		var dist := player.global_position.distance_to(current_target.global_position)
		if dist > detection_range * 1.5:
			release_target()
	elif current_target:
		release_target()
