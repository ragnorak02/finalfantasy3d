class_name AbilityData extends Resource

enum AbilityType { MELEE, PROJECTILE, AOE, MOVEMENT, DEFENSE }

@export var ability_name: StringName = &""
@export var display_name: String = ""
@export var description: String = ""
@export var icon: Texture2D

@export_group("Costs & Cooldown")
@export var mp_cost: float = 20.0
@export var cooldown: float = 5.0
@export var cast_time: float = 0.0

@export_group("Damage")
@export var damage: float = 25.0
@export var ability_type: AbilityType = AbilityType.MELEE

@export_group("Animation & Effects")
@export var animation_name: StringName = &""
@export var effect_scene: PackedScene
@export var vfx_scene: PackedScene
@export var sfx_cast: AudioStream
@export var sfx_impact: AudioStream

@export_group("Type-Specific")
@export var movement_distance: float = 0.0
@export var aoe_radius: float = 0.0
@export var cc_duration: float = 0.0
