extends PanelContainer

signal card_selected(index: int)

@onready var name_label: Label = $MarginContainer/HBoxContainer/NameLabel
@onready var mp_cost_label: Label = $MarginContainer/HBoxContainer/MpCostLabel

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

	if on_cooldown:
		modulate = Color(0.4, 0.4, 0.4, 1.0)
	elif not has_mp:
		modulate = Color(0.4, 0.4, 0.6, 1.0)
	else:
		modulate = Color.WHITE

func _gui_input(event: InputEvent) -> void:
	if is_available and event is InputEventMouseButton and event.pressed:
		card_selected.emit(card_index)
