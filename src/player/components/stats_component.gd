class_name StatsComponent extends Node

@export var stats_data: PlayerStatsData

var current_hp: float
var max_hp: float
var current_mp: float
var max_mp: float

func _ready() -> void:
	if stats_data:
		max_hp = stats_data.max_hp
		current_hp = max_hp
		max_mp = stats_data.max_mp
		current_mp = max_mp
	else:
		max_hp = 100.0
		current_hp = max_hp
		max_mp = 100.0
		current_mp = max_mp
	Events.player_hp_changed.emit(current_hp, max_hp)
	Events.player_mp_changed.emit(current_mp, max_mp)

func take_damage(amount: float, source: Node3D = null) -> void:
	current_hp = maxf(current_hp - amount, 0.0)
	Events.player_hp_changed.emit(current_hp, max_hp)
	Events.damage_received.emit(get_parent().get_parent(), amount, source)
	if current_hp <= 0.0:
		Events.player_died.emit()

func heal(amount: float) -> void:
	current_hp = minf(current_hp + amount, max_hp)
	Events.player_hp_changed.emit(current_hp, max_hp)

func spend_mp(amount: float) -> bool:
	if current_mp < amount:
		return false
	current_mp -= amount
	Events.player_mp_changed.emit(current_mp, max_mp)
	return true

func restore_mp(amount: float) -> void:
	current_mp = minf(current_mp + amount, max_mp)
	Events.player_mp_changed.emit(current_mp, max_mp)

func has_mp(amount: float) -> bool:
	return current_mp >= amount
