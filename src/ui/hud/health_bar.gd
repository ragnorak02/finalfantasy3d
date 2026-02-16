extends Control

@onready var progress_bar: ProgressBar = $ProgressBar
@onready var label: Label = $Label

func _ready() -> void:
	Events.player_hp_changed.connect(_on_hp_changed)

func _on_hp_changed(current: float, max_hp: float) -> void:
	if progress_bar:
		var tween := create_tween()
		tween.tween_property(progress_bar, "value", current / max_hp * 100.0, 0.3).set_ease(Tween.EASE_OUT)
	if label:
		label.text = "%d / %d" % [ceili(current), ceili(max_hp)]
