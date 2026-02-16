class_name Player extends CharacterBody3D

@export var stats_data: PlayerStatsData

@onready var state_machine: StateMachine = $StateMachine
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var player_model: Node3D = $PlayerModel
@onready var hitbox_pivot: Node3D = $HitboxPivot

# Components
@onready var stats_component: Node = $Components/StatsComponent
@onready var combat_component: Node = $Components/CombatComponent
@onready var ability_caster: Node = $Components/AbilityCaster
@onready var lock_on_component: Node = $Components/LockOnComponent
@onready var mp_regen_component: Node = $Components/MpRegenComponent
@onready var hurtbox_component: Area3D = $HurtboxComponent

# Timers
@onready var dodge_cooldown_timer: Timer = $DodgeCooldownTimer
@onready var combo_window_timer: Timer = $ComboWindowTimer

var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
var camera_yaw: float = 0.0
var lock_on_target: Node3D = null
var is_locked_on: bool = false
var dodge_ready: bool = true
var facing_direction: Vector3 = Vector3.FORWARD

func _ready() -> void:
	add_to_group(&"player")
	dodge_cooldown_timer.timeout.connect(_on_dodge_cooldown_timeout)
	hurtbox_component.hurt.connect(_on_hurt)
	Events.lock_on_target_acquired.connect(_on_lock_on_acquired)
	Events.lock_on_target_lost.connect(_on_lock_on_lost)
	Events.lock_on_target_switched.connect(_on_lock_on_switched)
	Events.camera_snap_rotation_requested.connect(_on_camera_rotated)
	_load_abilities()

func _load_abilities() -> void:
	var ability_paths: Array[String] = [
		"res://data/abilities/rising_blade.tres",
		"res://data/abilities/fire_bolt.tres",
		"res://data/abilities/ice_arc.tres",
		"res://data/abilities/wind_step.tres",
		"res://data/abilities/lightning_thrust.tres",
		"res://data/abilities/guardian_rune.tres",
	]
	for i in ability_paths.size():
		var data := load(ability_paths[i]) as AbilityData
		if data:
			ability_caster.set_ability(i, data)

func get_movement_input() -> Vector3:
	var input_vec := InputManager.get_movement_vector()
	if input_vec.length() < 0.1:
		return Vector3.ZERO
	var forward := Vector3.FORWARD.rotated(Vector3.UP, camera_yaw)
	var right := Vector3.RIGHT.rotated(Vector3.UP, camera_yaw)
	var direction := (forward * -input_vec.y + right * input_vec.x).normalized()
	return direction

func apply_gravity(delta: float) -> void:
	if not is_on_floor():
		var grav_mult := stats_data.gravity_multiplier if stats_data else 2.0
		velocity.y -= gravity * grav_mult * delta

func face_direction(direction: Vector3, delta: float, rotation_speed: float = 12.0) -> void:
	if direction.length() < 0.01:
		return
	var target_angle := atan2(direction.x, direction.z)
	player_model.rotation.y = lerp_angle(player_model.rotation.y, target_angle, rotation_speed * delta)
	facing_direction = direction.normalized()
	hitbox_pivot.rotation.y = player_model.rotation.y

func face_target(delta: float) -> void:
	if lock_on_target == null:
		return
	var dir := (lock_on_target.global_position - global_position)
	dir.y = 0.0
	face_direction(dir.normalized(), delta, 15.0)

func start_dodge_cooldown() -> void:
	dodge_ready = false
	var cd := stats_data.dodge_cooldown if stats_data else 0.8
	dodge_cooldown_timer.start(cd)

func _on_dodge_cooldown_timeout() -> void:
	dodge_ready = true

func _on_lock_on_acquired(target: Node3D) -> void:
	lock_on_target = target
	is_locked_on = true

func _on_lock_on_lost() -> void:
	lock_on_target = null
	is_locked_on = false

func _on_lock_on_switched(new_target: Node3D) -> void:
	lock_on_target = new_target

func _on_camera_rotated(_direction: int) -> void:
	# Camera rig will update camera_yaw directly
	pass

func _on_hurt(hitbox: HitboxComponent) -> void:
	stats_component.take_damage(hitbox.damage, hitbox.source)
	if stats_component.current_hp > 0.0:
		state_machine.force_transition(&"Flinch")
