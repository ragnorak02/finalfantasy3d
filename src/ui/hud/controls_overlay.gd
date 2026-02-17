extends PanelContainer

const KB_BINDINGS: Array[Array] = [
	["Move", "WASD"],
	["Camera", "Mouse"],
	["Attack", "LClick"],
	["Magic", "RClick"],
	["Jump", "Space"],
	["Dodge", "Shift"],
	["Sprint", "Ctrl"],
	["Lock-On", "Tab"],
	["Tactical", "Q"],
	["Pause", "Esc"],
]

const XBOX_BINDINGS: Array[Array] = [
	["Move", "LS"],
	["Camera", "RS"],
	["Attack", "X"],
	["Magic", "Y"],
	["Dodge", "B"],
	["Jump", "A"],
	["Sprint", "LT"],
	["Lock-On", "RT"],
	["Tactical", "LB"],
	["Pause", "Start"],
]

var _label_container: HBoxContainer

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	mouse_filter = Control.MOUSE_FILTER_IGNORE

	# Panel styling
	var style := StyleBoxFlat.new()
	style.bg_color = Color(0.0, 0.0, 0.0, 0.5)
	style.content_margin_left = 16.0
	style.content_margin_right = 16.0
	style.content_margin_top = 8.0
	style.content_margin_bottom = 8.0
	add_theme_stylebox_override(&"panel", style)

	# Anchor to bottom, full width
	set_anchors_preset(Control.PRESET_BOTTOM_WIDE)
	offset_top = -60.0

	_label_container = HBoxContainer.new()
	_label_container.alignment = BoxContainer.ALIGNMENT_CENTER
	_label_container.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(_label_container)

	_rebuild_labels(InputManager.is_using_controller())
	InputManager.input_device_changed.connect(_on_device_changed)

func _unhandled_key_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and event.physical_keycode == KEY_F1:
		visible = !visible
		get_viewport().set_input_as_handled()

func _on_device_changed(device_type: StringName) -> void:
	_rebuild_labels(device_type == &"controller")

func _rebuild_labels(is_controller: bool) -> void:
	for child in _label_container.get_children():
		child.queue_free()

	var bindings: Array[Array] = XBOX_BINDINGS if is_controller else KB_BINDINGS
	for i in bindings.size():
		var pair: Array = bindings[i]
		var label := Label.new()
		label.text = "%s–%s" % [pair[0], pair[1]]
		label.add_theme_font_size_override(&"font_size", 14)
		label.add_theme_color_override(&"font_color", Color(0.9, 0.85, 0.7))
		label.mouse_filter = Control.MOUSE_FILTER_IGNORE
		_label_container.add_child(label)

		if i < bindings.size() - 1:
			var spacer := Control.new()
			spacer.custom_minimum_size.x = 20.0
			spacer.mouse_filter = Control.MOUSE_FILTER_IGNORE
			_label_container.add_child(spacer)
