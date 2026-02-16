extends HBoxContainer

const SLOT_KEYS := ["1", "2", "3", "4", "5", "6"]

func _ready() -> void:
	for i in get_child_count():
		var slot := get_child(i)
		if slot.has_method("setup"):
			slot.setup(i, SLOT_KEYS[i] if i < SLOT_KEYS.size() else "?")
	# Defer icon loading until player abilities are set
	await get_tree().create_timer(0.1).timeout
	_load_ability_icons()

func _load_ability_icons() -> void:
	var player := get_tree().get_first_node_in_group(&"player") as CharacterBody3D
	if player == null or not player.has_node("Components/AbilityCaster"):
		return
	var caster: AbilityCaster = player.get_node("Components/AbilityCaster")
	for i in get_child_count():
		var slot := get_child(i)
		var ability := caster.get_ability(i)
		if ability and ability.icon and slot.has_method("set_ability_icon"):
			slot.set_ability_icon(ability.icon)
