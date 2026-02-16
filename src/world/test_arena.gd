extends Node3D

func _ready() -> void:
	GameManager.change_state(GameManager.GameState.PLAYING)
