class_name EnemyBase extends CharacterBody3D

@export var max_hp: float = 100.0
var current_hp: float

@onready var hurtbox: HurtboxComponent = $HurtboxComponent

func _ready() -> void:
	current_hp = max_hp
	add_to_group(&"enemies")
	if hurtbox:
		hurtbox.hurt.connect(_on_hurt)

func _on_hurt(hitbox: HitboxComponent) -> void:
	take_damage(hitbox.damage, hitbox.source)

func take_damage(amount: float, _source: Node3D = null) -> void:
	current_hp -= amount
	_on_damage_visual()
	if current_hp <= 0.0:
		die()

func _on_damage_visual() -> void:
	var mesh := _find_mesh()
	if mesh and mesh.get_surface_override_material(0):
		var mat: StandardMaterial3D = mesh.get_surface_override_material(0)
		var original_color := mat.albedo_color
		mat.albedo_color = Color.RED
		await get_tree().create_timer(0.1).timeout
		if is_instance_valid(self) and mat:
			mat.albedo_color = original_color

func _find_mesh() -> MeshInstance3D:
	for child in get_children():
		if child is MeshInstance3D:
			return child
		for grandchild in child.get_children():
			if grandchild is MeshInstance3D:
				return grandchild
	return null

func die() -> void:
	queue_free()
