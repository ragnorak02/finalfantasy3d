extends Control

@onready var reticle_sprite: TextureRect = $ReticleSprite

var target: Node3D = null
var camera: Camera3D = null

func _ready() -> void:
	visible = false
	Events.lock_on_target_acquired.connect(_on_target_acquired)
	Events.lock_on_target_lost.connect(_on_target_lost)
	Events.lock_on_target_switched.connect(_on_target_switched)

func _process(_delta: float) -> void:
	if target == null or not is_instance_valid(target) or camera == null:
		visible = false
		return
	visible = true
	var screen_pos := camera.unproject_position(target.global_position + Vector3.UP * 2.0)
	global_position = screen_pos - size * 0.5

func _on_target_acquired(new_target: Node3D) -> void:
	target = new_target
	camera = get_viewport().get_camera_3d()
	visible = true

func _on_target_lost() -> void:
	target = null
	visible = false

func _on_target_switched(new_target: Node3D) -> void:
	target = new_target
