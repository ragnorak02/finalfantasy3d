class_name BaseProjectile extends Area3D

@export var speed: float = 20.0
@export var lifetime: float = 3.0

var direction: Vector3 = Vector3.FORWARD
var damage: float = 10.0
var source: Node3D
var _timer: float = 0.0

func _ready() -> void:
	area_entered.connect(_on_area_entered)
	body_entered.connect(_on_body_entered)

func launch(dir: Vector3, dmg: float, src: Node3D) -> void:
	direction = dir.normalized()
	damage = dmg
	source = src
	look_at(global_position + direction)

func _physics_process(delta: float) -> void:
	global_position += direction * speed * delta
	_timer += delta
	if _timer >= lifetime:
		queue_free()

func _on_area_entered(area: Area3D) -> void:
	if area is HurtboxComponent:
		var target_root := area.get_parent()
		if target_root == source:
			return
		area.receive_hit(null)
		if target_root.has_method("take_damage"):
			target_root.take_damage(damage, source)
		Events.damage_dealt.emit(target_root, damage, source)
		queue_free()

func _on_body_entered(body: Node3D) -> void:
	if body == source:
		return
	if body is StaticBody3D:
		queue_free()
