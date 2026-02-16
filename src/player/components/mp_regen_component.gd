class_name MpRegenComponent extends Node

var _stats: StatsComponent
var _delay_timer: float = 0.0
var _regen_active: bool = true

func _ready() -> void:
	await get_tree().process_frame
	var player := get_parent().get_parent()
	if player:
		_stats = player.stats_component
	Events.player_mp_changed.connect(_on_mp_changed)

func _process(delta: float) -> void:
	if _stats == null:
		return
	if _delay_timer > 0.0:
		_delay_timer -= delta
		return
	if not _regen_active:
		_regen_active = true
	if _stats.current_mp < _stats.max_mp:
		var rate: float = _stats.stats_data.mp_regen_rate if _stats.stats_data else 5.0
		_stats.restore_mp(rate * delta)

func _on_mp_changed(current: float, max_mp: float) -> void:
	if current < max_mp:
		if not _regen_active:
			return
		var delay: float = _stats.stats_data.mp_regen_delay if _stats and _stats.stats_data else 2.0
		_delay_timer = delay
		_regen_active = false
