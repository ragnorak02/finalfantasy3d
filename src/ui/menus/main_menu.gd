extends Control

@onready var play_button: Button = $CenterContainer/VBoxContainer/PlayButton
@onready var options_button: Button = $CenterContainer/VBoxContainer/OptionsButton
@onready var quit_button: Button = $CenterContainer/VBoxContainer/QuitButton
@onready var options_menu: Control = $OptionsMenu

func _ready() -> void:
	play_button.pressed.connect(_on_play)
	options_button.pressed.connect(_on_options)
	quit_button.pressed.connect(_on_quit)
	play_button.grab_focus()
	GameManager.change_state(GameManager.GameState.MAIN_MENU)

func _on_play() -> void:
	GameManager.change_state(GameManager.GameState.PLAYING)
	GameManager.load_scene("res://src/world/test_arena.tscn")

func _on_options() -> void:
	options_menu.visible = true
	options_menu.grab_initial_focus()

func _on_quit() -> void:
	GameManager.quit_game()
