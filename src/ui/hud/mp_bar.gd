extends Control

@onready var progress_bar: ProgressBar = $ProgressBar
@onready var label: Label = $Label

func _ready() -> void:
	Events.player_mp_changed.connect(_on_mp_changed)

func _on_mp_changed(current: float, max_mp: float) -> void:
	if progress_bar:
		var tween := create_tween()
		tween.tween_property(progress_bar, "value", current / max_mp * 100.0, 0.2).set_ease(Tween.EASE_OUT)
	if label:
		label.text = "%d / %d" % [ceili(current), ceili(max_mp)]
