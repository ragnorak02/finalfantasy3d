extends Control

@onready var master_slider: HSlider = $PanelContainer/VBoxContainer/MasterVolume/HSlider
@onready var sfx_slider: HSlider = $PanelContainer/VBoxContainer/SFXVolume/HSlider
@onready var music_slider: HSlider = $PanelContainer/VBoxContainer/MusicVolume/HSlider
@onready var fullscreen_check: CheckBox = $PanelContainer/VBoxContainer/Fullscreen/CheckBox
@onready var back_button: Button = $PanelContainer/VBoxContainer/BackButton

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	back_button.pressed.connect(_on_back)
	master_slider.value_changed.connect(_on_master_changed)
	sfx_slider.value_changed.connect(_on_sfx_changed)
	music_slider.value_changed.connect(_on_music_changed)
	fullscreen_check.toggled.connect(_on_fullscreen_toggled)
	master_slider.value = db_to_linear(AudioServer.get_bus_volume_db(0))
	var sfx_idx := AudioServer.get_bus_index("SFX")
	if sfx_idx >= 0:
		sfx_slider.value = db_to_linear(AudioServer.get_bus_volume_db(sfx_idx))
	var music_idx := AudioServer.get_bus_index("Music")
	if music_idx >= 0:
		music_slider.value = db_to_linear(AudioServer.get_bus_volume_db(music_idx))

func grab_initial_focus() -> void:
	if back_button:
		back_button.grab_focus()

func _on_master_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(0, linear_to_db(value))

func _on_sfx_changed(value: float) -> void:
	var idx := AudioServer.get_bus_index("SFX")
	if idx >= 0:
		AudioServer.set_bus_volume_db(idx, linear_to_db(value))

func _on_music_changed(value: float) -> void:
	var idx := AudioServer.get_bus_index("Music")
	if idx >= 0:
		AudioServer.set_bus_volume_db(idx, linear_to_db(value))

func _on_fullscreen_toggled(toggled: bool) -> void:
	if toggled:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

func _on_back() -> void:
	visible = false
