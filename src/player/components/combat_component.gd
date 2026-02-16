class_name CombatComponent extends Node

@export var combo_data: ComboChainData

var combo_index: int = 0
var in_combo_window: bool = false

func get_current_attack() -> AttackMoveData:
	if combo_data == null or combo_data.attacks.is_empty():
		return null
	combo_index = clampi(combo_index, 0, combo_data.attacks.size() - 1)
	return combo_data.attacks[combo_index]

func get_heavy_finisher() -> AttackMoveData:
	if combo_data == null:
		return null
	return combo_data.heavy_finisher

func advance_combo() -> void:
	combo_index += 1
	if combo_data and combo_index >= combo_data.attacks.size():
		combo_index = combo_data.attacks.size() - 1
	Events.combo_count_changed.emit(combo_index + 1)

func reset_combo() -> void:
	combo_index = 0
	in_combo_window = false
	Events.combo_reset.emit()

func get_max_combo() -> int:
	if combo_data == null:
		return 0
	return combo_data.attacks.size()

func calculate_damage(base_damage: float, multiplier: float) -> float:
	return base_damage * multiplier
