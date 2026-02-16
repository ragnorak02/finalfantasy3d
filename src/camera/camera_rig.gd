class_name CameraRig extends Node3D

@export var target: Node3D
@export var follow_speed: float = 8.0
@export var rotation_speed: float = 8.0
@export var default_ortho_size: float = 16.0
@export var lockon_ortho_size: float = 20.0
@export var pitch_angle: float = -35.0

@onready var yaw_pivot: Node3D = $YawPivot
@onready var pitch_pivot: Node3D = $YawPivot/PitchPivot
@onready var spring_arm: SpringArm3D = $YawPivot/PitchPivot/SpringArm3D
@onready var camera: Camera3D = $YawPivot/PitchPivot/SpringArm3D/Camera3D

var target_yaw: float = 0.0
var current_yaw: float = 0.0
var is_locked_on: bool = false
var lock_on_target: Node3D = null

# Camera shake
var _shake_intensity: float = 0.0
var _shake_duration: float = 0.0
var _shake_timer: float = 0.0
var _shake_offset: Vector3 = Vector3.ZERO

func _ready() -> void:
	pitch_pivot.rotation_degrees.x = pitch_angle
	camera.projection = Camera3D.PROJECTION_ORTHOGONAL
	camera.size = default_ortho_size

	Events.camera_snap_rotation_requested.connect(_on_snap_rotation)
	Events.camera_shake_requested.connect(_on_shake_requested)
	Events.lock_on_target_acquired.connect(_on_lock_on_acquired)
	Events.lock_on_target_lost.connect(_on_lock_on_lost)
	Events.lock_on_target_switched.connect(_on_lock_on_switched)

func _process(delta: float) -> void:
	_follow_target(delta)
	_update_yaw(delta)
	_update_ortho_size(delta)
	_update_shake(delta)

func _follow_target(delta: float) -> void:
	if target == null:
		return
	global_position = global_position.lerp(target.global_position, follow_speed * delta)

func _update_yaw(delta: float) -> void:
	current_yaw = lerp_angle(current_yaw, target_yaw, rotation_speed * delta)
	yaw_pivot.rotation.y = current_yaw
	# Update player's camera_yaw reference
	if target and target.has_method("get") and target is CharacterBody3D:
		target.set(&"camera_yaw", current_yaw)

func _update_ortho_size(delta: float) -> void:
	var target_size := lockon_ortho_size if is_locked_on else default_ortho_size
	camera.size = lerp(camera.size, target_size, 4.0 * delta)

func _update_shake(delta: float) -> void:
	if _shake_timer <= 0.0:
		camera.position = Vector3.ZERO
		return
	_shake_timer -= delta
	var decay := _shake_timer / _shake_duration
	_shake_offset = Vector3(
		randf_range(-1.0, 1.0) * _shake_intensity * decay,
		randf_range(-1.0, 1.0) * _shake_intensity * decay,
		0.0
	)
	camera.position = _shake_offset

func _on_snap_rotation(direction: int) -> void:
	target_yaw += deg_to_rad(90.0) * direction

func _on_shake_requested(intensity: float, duration: float) -> void:
	_shake_intensity = intensity
	_shake_duration = duration
	_shake_timer = duration

func _on_lock_on_acquired(lock_target: Node3D) -> void:
	is_locked_on = true
	lock_on_target = lock_target

func _on_lock_on_lost() -> void:
	is_locked_on = false
	lock_on_target = null

func _on_lock_on_switched(new_target: Node3D) -> void:
	lock_on_target = new_target

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed(&"camera_rotate_left"):
		Events.camera_snap_rotation_requested.emit(1)
	elif event.is_action_pressed(&"camera_rotate_right"):
		Events.camera_snap_rotation_requested.emit(-1)
