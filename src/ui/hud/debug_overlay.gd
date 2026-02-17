extends PanelContainer

var _vbox: VBoxContainer
var _label_last_input: Label
var _label_device: Label
var _label_player_state: Label
var _label_game_state: Label
var _label_mp: Label
var _label_lock_target: Label
var _label_fps: Label
var _label_stuck_warning: Label

var _current_player_state: StringName = &"idle"
var _state_timer: float = 0.0
var _current_mp: float = 0.0
var _max_mp: float = 0.0
var _lock_target_name: String = "None"
var _last_input_text: String = "None"

const STUCK_THRESHOLD: float = 10.0

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	visible = false

	# Panel styling
	var style := StyleBoxFlat.new()
	style.bg_color = Color(0.0, 0.0, 0.0, 0.6)
	style.content_margin_left = 12.0
	style.content_margin_right = 12.0
	style.content_margin_top = 8.0
	style.content_margin_bottom = 8.0
	style.corner_radius_bottom_left = 4
	style.corner_radius_top_left = 4
	add_theme_stylebox_override(&"panel", style)

	# Anchor top-right
	set_anchors_preset(Control.PRESET_TOP_RIGHT)
	offset_left = -280.0
	offset_bottom = 220.0
	offset_right = 0.0
	offset_top = 0.0

	_vbox = VBoxContainer.new()
	_vbox.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(_vbox)

	var title := Label.new()
	title.text = "DEBUG (F2)"
	title.add_theme_font_size_override(&"font_size", 14)
	title.add_theme_color_override(&"font_color", Color(1.0, 0.85, 0.3))
	title.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_vbox.add_child(title)

	_label_last_input = _add_label("Last Input: None")
	_label_device = _add_label("Device: Keyboard")
	_label_player_state = _add_label("Player State: idle")
	_label_game_state = _add_label("Game State: PLAYING")
	_label_mp = _add_label("MP: 0 / 0")
	_label_lock_target = _add_label("Lock Target: None")
	_label_fps = _add_label("FPS: 0")
	_label_stuck_warning = _add_label("")
	_label_stuck_warning.add_theme_color_override(&"font_color", Color(1.0, 0.2, 0.2))

	# Connect signals
	Events.player_state_changed.connect(_on_player_state_changed)
	Events.player_mp_changed.connect(_on_mp_changed)
	Events.lock_on_target_acquired.connect(_on_lock_acquired)
	Events.lock_on_target_lost.connect(_on_lock_lost)
	Events.lock_on_target_switched.connect(_on_lock_switched)
	InputManager.input_device_changed.connect(_on_device_changed)

func _add_label(text: String) -> Label:
	var label := Label.new()
	label.text = text
	label.add_theme_font_size_override(&"font_size", 13)
	label.add_theme_color_override(&"font_color", Color(0.85, 0.85, 0.85))
	label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_vbox.add_child(label)
	return label

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		_last_input_text = OS.get_keycode_string(event.physical_keycode)
	elif event is InputEventMouseButton and event.pressed:
		match event.button_index:
			MOUSE_BUTTON_LEFT: _last_input_text = "LClick"
			MOUSE_BUTTON_RIGHT: _last_input_text = "RClick"
			MOUSE_BUTTON_MIDDLE: _last_input_text = "MClick"
			_: _last_input_text = "Mouse%d" % event.button_index
	elif event is InputEventJoypadButton and event.pressed:
		_last_input_text = "Pad_%d" % event.button_index
	elif event is InputEventJoypadMotion and absf(event.axis_value) > 0.5:
		_last_input_text = "Axis%d: %.1f" % [event.axis, event.axis_value]

func _unhandled_key_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and event.physical_keycode == KEY_F2:
		visible = !visible
		get_viewport().set_input_as_handled()

func _process(delta: float) -> void:
	if not visible:
		return

	_state_timer += delta

	_label_last_input.text = "Last Input: %s" % _last_input_text
	_label_device.text = "Device: %s" % ("Controller" if InputManager.is_using_controller() else "Keyboard")
	_label_player_state.text = "Player State: %s" % _current_player_state
	_label_game_state.text = "Game State: %s" % _get_game_state_name()
	_label_mp.text = "MP: %.0f / %.0f" % [_current_mp, _max_mp]
	_label_lock_target.text = "Lock Target: %s" % _lock_target_name
	_label_fps.text = "FPS: %d" % Engine.get_frames_per_second()

	if _current_player_state != &"idle" and _state_timer > STUCK_THRESHOLD:
		_label_stuck_warning.text = "STUCK? %s for %.0fs" % [_current_player_state, _state_timer]
	else:
		_label_stuck_warning.text = ""

func _get_game_state_name() -> String:
	match GameManager.current_state:
		GameManager.GameState.PLAYING: return "PLAYING"
		GameManager.GameState.PAUSED: return "PAUSED"
		GameManager.GameState.TACTICAL_MODE: return "TACTICAL"
		GameManager.GameState.MAIN_MENU: return "MAIN_MENU"
	return "UNKNOWN"

func _on_player_state_changed(_old_state: StringName, new_state: StringName) -> void:
	_current_player_state = new_state
	_state_timer = 0.0

func _on_mp_changed(current: float, max_mp: float) -> void:
	_current_mp = current
	_max_mp = max_mp

func _on_lock_acquired(target: Node3D) -> void:
	_lock_target_name = target.name if target else "None"

func _on_lock_lost() -> void:
	_lock_target_name = "None"

func _on_lock_switched(new_target: Node3D) -> void:
	_lock_target_name = new_target.name if new_target else "None"

func _on_device_changed(_device_type: StringName) -> void:
	pass # Updated every frame from InputManager directly
