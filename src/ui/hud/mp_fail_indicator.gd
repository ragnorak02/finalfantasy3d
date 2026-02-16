extends Control

@onready var flash_rect: ColorRect = $FlashRect

func _ready() -> void:
	Events.mp_fail_flash_requested.connect(_on_flash_requested)
	if flash_rect:
		flash_rect.modulate.a = 0.0

func _on_flash_requested() -> void:
	if flash_rect == null:
		return
	flash_rect.modulate.a = 0.6
	var tween := create_tween()
	tween.tween_property(flash_rect, "modulate:a", 0.0, 0.4).set_ease(Tween.EASE_OUT)
