extends PanelContainer

signal card_selected(index: int)

@onready var name_label: Label = $MarginContainer/VBoxContainer/NameLabel
@onready var icon_rect: TextureRect = $MarginContainer/VBoxContainer/IconRect
@onready var mp_cost_label: Label = $MarginContainer/VBoxContainer/MpCostLabel
@onready var description_label: Label = $MarginContainer/VBoxContainer/DescriptionLabel
@onready var cooldown_label: Label = $MarginContainer/VBoxContainer/CooldownLabel

var card_index: int = 0
var ability_data: AbilityData
var is_available: bool = true

func setup(index: int, data: AbilityData, on_cooldown: bool, has_mp: bool) -> void:
	card_index = index
	ability_data = data
	is_available = not on_cooldown and has_mp and data != null

	if data == null:
		visible = false
		return

	visible = true
	name_label.text = data.display_name if data.display_name != "" else str(data.ability_name)
	mp_cost_label.text = "MP: %d" % data.mp_cost
	description_label.text = data.description

	if on_cooldown:
		cooldown_label.text = "ON COOLDOWN"
		cooldown_label.visible = true
		modulate = Color(0.4, 0.4, 0.4, 1.0)
	elif not has_mp:
		cooldown_label.text = "NOT ENOUGH MP"
		cooldown_label.visible = true
		modulate = Color(0.4, 0.4, 0.6, 1.0)
	else:
		cooldown_label.visible = false
		modulate = Color.WHITE

	if data.icon:
		icon_rect.texture = data.icon

func _gui_input(event: InputEvent) -> void:
	if is_available and event is InputEventMouseButton and event.pressed:
		card_selected.emit(card_index)
