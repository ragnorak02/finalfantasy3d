extends Node

enum GameState { MAIN_MENU, PLAYING, PAUSED, TACTICAL_MODE }

var current_state: GameState = GameState.MAIN_MENU
var _previous_state: GameState = GameState.MAIN_MENU

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS

func change_state(new_state: GameState) -> void:
	if current_state == new_state:
		return
	_previous_state = current_state
	current_state = new_state

	match new_state:
		GameState.PLAYING:
			Engine.time_scale = 1.0
			get_tree().paused = false
			Events.game_resumed.emit()
		GameState.PAUSED:
			get_tree().paused = true
			Events.game_paused.emit()
		GameState.TACTICAL_MODE:
			Engine.time_scale = 0.1
			Events.tactical_mode_entered.emit()
		GameState.MAIN_MENU:
			Engine.time_scale = 1.0
			get_tree().paused = false

func exit_tactical_mode() -> void:
	if current_state == GameState.TACTICAL_MODE:
		change_state(GameState.PLAYING)
		Events.tactical_mode_exited.emit()

func toggle_pause() -> void:
	if current_state == GameState.PLAYING:
		change_state(GameState.PAUSED)
	elif current_state == GameState.PAUSED:
		change_state(GameState.PLAYING)

func load_scene(scene_path: String) -> void:
	get_tree().change_scene_to_file(scene_path)

func quit_game() -> void:
	get_tree().quit()
