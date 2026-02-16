class_name PlayerStatsData extends Resource

@export_group("Health & Mana")
@export var max_hp: float = 100.0
@export var max_mp: float = 100.0
@export var mp_regen_rate: float = 5.0
@export var mp_regen_delay: float = 2.0

@export_group("Movement")
@export var move_speed: float = 7.0
@export var sprint_speed: float = 12.0
@export var jump_force: float = 10.0
@export var gravity_multiplier: float = 2.0

@export_group("Dodge")
@export var dodge_speed: float = 15.0
@export var dodge_duration: float = 0.4
@export var dodge_cooldown: float = 0.8
@export var dodge_iframe_start: float = 0.05
@export var dodge_iframe_end: float = 0.3

@export_group("Combat")
@export var attack_base_damage: float = 10.0
@export var tactical_mp_drain_rate: float = 10.0
