class_name State extends Node

var state_machine: StateMachine
var player: CharacterBody3D

func setup(sm: StateMachine, p: CharacterBody3D) -> void:
	state_machine = sm
	player = p

func enter(_prev_state: StringName) -> void:
	pass

func exit(_next_state: StringName) -> void:
	pass

func process_frame(_delta: float) -> StringName:
	return &""

func process_physics(_delta: float) -> StringName:
	return &""

func process_input(_event: InputEvent) -> StringName:
	return &""
