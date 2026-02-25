extends VBoxContainer

@onready var count_label: Label = $CountLabel
@onready var grade_label: Label = $GradeLabel

var _hide_timer: float = 0.0
var _hit_count: int = 0

const HIDE_DELAY := 2.0

const COLOR_S := Color(1.0, 0.85, 0.2)
const COLOR_A := Color(0.3, 1.0, 0.3)
const COLOR_B := Color(0.3, 0.85, 1.0)
const COLOR_C := Color(1.0, 1.0, 1.0)
const COLOR_D := Color(0.6, 0.6, 0.6)

func _ready() -> void:
	visible = false
	Events.damage_dealt.connect(_on_damage_dealt)
	Events.combo_reset.connect(_on_combo_reset)

func _on_damage_dealt(_target: Node3D, _amount: float, _source: Node3D) -> void:
	_hit_count += 1
	_hide_timer = HIDE_DELAY
	visible = true
	_update_display()

func _on_combo_reset() -> void:
	_hide_timer = 0.8

func _process(delta: float) -> void:
	if not visible:
		return
	_hide_timer -= delta
	if _hide_timer <= 0.0:
		visible = false
		_hit_count = 0

func _update_display() -> void:
	count_label.text = str(_hit_count)
	var grade := _get_grade()
	grade_label.text = grade
	grade_label.modulate = _get_grade_color(grade)
	var tween := create_tween()
	tween.tween_property(count_label, "scale", Vector2(1.3, 1.3), 0.05)
	tween.tween_property(count_label, "scale", Vector2.ONE, 0.1)

func _get_grade() -> String:
	if _hit_count >= 8: return "S"
	if _hit_count >= 6: return "A"
	if _hit_count >= 4: return "B"
	if _hit_count >= 2: return "C"
	return "D"

func _get_grade_color(grade: String) -> Color:
	match grade:
		"S": return COLOR_S
		"A": return COLOR_A
		"B": return COLOR_B
		"C": return COLOR_C
		_: return COLOR_D
