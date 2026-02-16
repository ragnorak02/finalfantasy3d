extends PanelContainer

@onready var icon_rect: TextureRect = $MarginContainer/VBoxContainer/IconRect
@onready var cooldown_overlay: ColorRect = $MarginContainer/VBoxContainer/IconRect/CooldownOverlay
@onready var key_label: Label = $MarginContainer/VBoxContainer/KeyLabel

var slot_index: int = 0
var _cooldown_duration: float = 0.0
var _cooldown_remaining: float = 0.0

func _ready() -> void:
	Events.ability_cooldown_started.connect(_on_cooldown_started)
	Events.ability_cooldown_finished.connect(_on_cooldown_finished)
	if cooldown_overlay:
		cooldown_overlay.visible = false

func setup(index: int, key_text: String) -> void:
	slot_index = index
	if key_label:
		key_label.text = key_text

func set_ability_icon(texture: Texture2D) -> void:
	if icon_rect:
		icon_rect.texture = texture

func _on_cooldown_started(index: int, duration: float) -> void:
	if index != slot_index:
		return
	_cooldown_duration = duration
	_cooldown_remaining = duration
	if cooldown_overlay:
		cooldown_overlay.visible = true

func _on_cooldown_finished(index: int) -> void:
	if index != slot_index:
		return
	_cooldown_remaining = 0.0
	if cooldown_overlay:
		cooldown_overlay.visible = false
	_flash_ready()

func _flash_ready() -> void:
	var tween := create_tween()
	self_modulate = Color(1.5, 1.5, 1.0, 1.0)
	tween.tween_property(self, "self_modulate", Color.WHITE, 0.3).set_ease(Tween.EASE_OUT)

func _process(delta: float) -> void:
	if _cooldown_remaining > 0.0:
		_cooldown_remaining -= delta
		if cooldown_overlay and _cooldown_duration > 0.0:
			var progress := 1.0 - (_cooldown_remaining / _cooldown_duration)
			cooldown_overlay.anchor_top = progress
		if _cooldown_remaining <= 0.0 and cooldown_overlay:
			cooldown_overlay.visible = false
			_flash_ready()
