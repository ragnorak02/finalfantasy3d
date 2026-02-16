class_name AbilityCaster extends Node

const MAX_SLOTS := 6

var abilities: Array[AbilityData] = []
var cooldown_timers: Array[float] = []
var _stats: StatsComponent

func _ready() -> void:
	abilities.resize(MAX_SLOTS)
	cooldown_timers.resize(MAX_SLOTS)
	cooldown_timers.fill(0.0)
	await get_tree().process_frame
	var player := get_parent().get_parent()
	if player:
		_stats = player.stats_component

func _process(delta: float) -> void:
	for i in MAX_SLOTS:
		if cooldown_timers[i] > 0.0:
			cooldown_timers[i] -= delta
			if cooldown_timers[i] <= 0.0:
				cooldown_timers[i] = 0.0
				Events.ability_cooldown_finished.emit(i)

func set_ability(index: int, ability: AbilityData) -> void:
	if index >= 0 and index < MAX_SLOTS:
		abilities[index] = ability

func try_cast(index: int) -> bool:
	if index < 0 or index >= MAX_SLOTS:
		return false
	var ability := abilities[index]
	if ability == null:
		return false
	if cooldown_timers[index] > 0.0:
		return false
	if _stats and not _stats.has_mp(ability.mp_cost):
		Events.ability_cast_failed_no_mp.emit(ability)
		Events.mp_fail_flash_requested.emit()
		return false
	if _stats:
		_stats.spend_mp(ability.mp_cost)
	cooldown_timers[index] = ability.cooldown
	Events.ability_cooldown_started.emit(index, ability.cooldown)
	Events.ability_cast_started.emit(ability)
	return true

func get_ability(index: int) -> AbilityData:
	if index >= 0 and index < MAX_SLOTS:
		return abilities[index]
	return null

func is_on_cooldown(index: int) -> bool:
	if index >= 0 and index < MAX_SLOTS:
		return cooldown_timers[index] > 0.0
	return true

func get_cooldown_remaining(index: int) -> float:
	if index >= 0 and index < MAX_SLOTS:
		return cooldown_timers[index]
	return 0.0
