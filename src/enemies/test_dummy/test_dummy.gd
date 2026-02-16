extends EnemyBase

@export var respawn_hp: bool = true

func take_damage(amount: float, _source: Node3D = null) -> void:
	current_hp -= amount
	_on_damage_visual()
	if current_hp <= 0.0 and respawn_hp:
		current_hp = max_hp

func die() -> void:
	current_hp = max_hp
