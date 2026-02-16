extends Control

@onready var resume_button: Button = $PanelContainer/VBoxContainer/ResumeButton
@onready var options_button: Button = $PanelContainer/VBoxContainer/OptionsButton
@onready var main_menu_button: Button = $PanelContainer/VBoxContainer/MainMenuButton
@onready var options_menu: Control = $OptionsMenu

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	visible = false
	resume_button.pressed.connect(_on_resume)
	options_button.pressed.connect(_on_options)
	main_menu_button.pressed.connect(_on_main_menu)
	Events.game_paused.connect(_on_game_paused)
	Events.game_resumed.connect(_on_game_resumed)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed(&"pause"):
		if GameManager.current_state == GameManager.GameState.PLAYING:
			GameManager.toggle_pause()
		elif GameManager.current_state == GameManager.GameState.PAUSED:
			GameManager.toggle_pause()
		get_viewport().set_input_as_handled()

func _on_game_paused() -> void:
	visible = true
	resume_button.grab_focus()

func _on_game_resumed() -> void:
	visible = false
	options_menu.visible = false

func _on_resume() -> void:
	GameManager.toggle_pause()

func _on_options() -> void:
	options_menu.visible = true
	options_menu.grab_initial_focus()

func _on_main_menu() -> void:
	GameManager.change_state(GameManager.GameState.MAIN_MENU)
	GameManager.load_scene("res://src/ui/menus/main_menu.tscn")
