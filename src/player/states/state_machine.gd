class_name StateMachine extends Node

@export var initial_state: State
@export var player: Player

var current_state: State
var states: Dictionary = {}

func _ready() -> void:
	for child in get_children():
		if child is State:
			states[child.name] = child
			child.setup(self, player)

	if initial_state:
		current_state = initial_state
		current_state.enter(&"")

func _process(delta: float) -> void:
	if current_state == null:
		return
	var next := current_state.process_frame(delta)
	if next != &"":
		_transition(next)

func _physics_process(delta: float) -> void:
	if current_state == null:
		return
	var next := current_state.process_physics(delta)
	if next != &"":
		_transition(next)

func _unhandled_input(event: InputEvent) -> void:
	if current_state == null:
		return
	var next := current_state.process_input(event)
	if next != &"":
		_transition(next)

func _transition(next_state_name: StringName) -> void:
	if not states.has(next_state_name):
		push_warning("StateMachine: State '%s' not found." % next_state_name)
		return

	var prev_name := current_state.name as StringName
	current_state.exit(next_state_name)
	current_state = states[next_state_name]
	current_state.enter(prev_name)
	Events.player_state_changed.emit(prev_name, next_state_name)

func force_transition(next_state_name: StringName) -> void:
	_transition(next_state_name)
