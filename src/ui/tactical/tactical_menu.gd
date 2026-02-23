extends Control

@onready var card_container: VBoxContainer = $PanelContainer/VBoxContainer
@onready var desaturation_overlay: ColorRect = $DesaturationOverlay

var _cards: Array = []
var _selected_index: int = 0
var _player: CharacterBody3D = null

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	visible = false
	Events.tactical_mode_entered.connect(_on_tactical_entered)
	Events.tactical_mode_exited.connect(_on_tactical_exited)

func _on_tactical_entered() -> void:
	_player = get_tree().get_first_node_in_group(&"player") as CharacterBody3D
	if _player == null:
		for node in get_tree().current_scene.get_children():
			if node is CharacterBody3D and node.has_node("Components/AbilityCaster"):
				_player = node
				break
	visible = true
	if desaturation_overlay:
		desaturation_overlay.visible = true
	_populate_cards()
	_selected_index = 0
	_update_selection()

func _on_tactical_exited() -> void:
	visible = false
	if desaturation_overlay:
		desaturation_overlay.visible = false

func _populate_cards() -> void:
	for child in card_container.get_children():
		child.queue_free()
	_cards.clear()

	if _player == null:
		return

	var caster: AbilityCaster = _player.ability_caster
	var stats: StatsComponent = _player.stats_component

	for i in caster.MAX_SLOTS:
		var ability := caster.get_ability(i)
		var card_scene := preload("res://src/ui/tactical/tactical_ability_card.tscn")
		var card := card_scene.instantiate()
		card_container.add_child(card)
		var on_cd := caster.is_on_cooldown(i)
		var has_mp := stats.has_mp(ability.mp_cost) if ability and stats else true
		card.setup(i, ability, on_cd, has_mp)
		card.card_selected.connect(_on_card_selected)
		_cards.append(card)

func _update_selection() -> void:
	for i in _cards.size():
		if i == _selected_index:
			_cards[i].self_modulate = Color(1.0, 0.85, 0.4, 1.0)
		else:
			_cards[i].self_modulate = Color(0.7, 0.7, 0.7, 1.0)

func _on_card_selected(index: int) -> void:
	_select_ability(index)

func _select_ability(index: int) -> void:
	Events.ability_selected_from_tactical.emit(index)
	if _player:
		_player.ability_caster.try_cast(index)
	GameManager.exit_tactical_mode()
	if _player:
		_player.state_machine.force_transition(&"Ability")

func _unhandled_input(event: InputEvent) -> void:
	if not visible:
		return
	if event.is_action_pressed(&"tactical_mode") or event.is_action_pressed(&"pause"):
		GameManager.exit_tactical_mode()
		get_viewport().set_input_as_handled()
		return
	if event.is_action_pressed(&"ui_up") or event.is_action_pressed(&"move_up"):
		_selected_index = (_selected_index - 1)
		if _selected_index < 0:
			_selected_index = _cards.size() - 1
		_update_selection()
		get_viewport().set_input_as_handled()
	elif event.is_action_pressed(&"ui_down") or event.is_action_pressed(&"move_down"):
		_selected_index = (_selected_index + 1) % _cards.size()
		_update_selection()
		get_viewport().set_input_as_handled()
	elif event.is_action_pressed(&"ui_accept") or event.is_action_pressed(&"attack"):
		if _selected_index >= 0 and _selected_index < _cards.size():
			if _cards[_selected_index].is_available:
				_select_ability(_selected_index)
		get_viewport().set_input_as_handled()
	for i in range(6):
		var action := &"ability_%d" % (i + 1)
		if event.is_action_pressed(action):
			if i < _cards.size() and _cards[i].is_available:
				_select_ability(i)
			get_viewport().set_input_as_handled()
