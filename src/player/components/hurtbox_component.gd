class_name HurtboxComponent extends Area3D

signal hurt(hitbox: HitboxComponent)

var is_invulnerable: bool = false

func receive_hit(hitbox: HitboxComponent) -> void:
	if is_invulnerable:
		return
	hurt.emit(hitbox)

func set_invulnerable(value: bool) -> void:
	is_invulnerable = value
