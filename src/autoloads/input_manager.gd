extends Node

signal input_device_changed(device_type: StringName)

enum DeviceType { KEYBOARD, CONTROLLER }

var current_device: DeviceType = DeviceType.KEYBOARD

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS

func _input(event: InputEvent) -> void:
	var new_device := current_device
	if event is InputEventKey or event is InputEventMouseButton or event is InputEventMouseMotion:
		new_device = DeviceType.KEYBOARD
	elif event is InputEventJoypadButton or event is InputEventJoypadMotion:
		if event is InputEventJoypadMotion and absf(event.axis_value) < 0.2:
			return
		new_device = DeviceType.CONTROLLER

	if new_device != current_device:
		current_device = new_device
		var device_name: StringName = &"keyboard" if current_device == DeviceType.KEYBOARD else &"controller"
		input_device_changed.emit(device_name)

func get_movement_vector() -> Vector2:
	return Input.get_vector(&"move_left", &"move_right", &"move_forward", &"move_back")

func is_using_controller() -> bool:
	return current_device == DeviceType.CONTROLLER
