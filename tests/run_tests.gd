extends Node

var _results: Array[Dictionary] = []
var _start_time: int


func _ready() -> void:
	_start_time = Time.get_ticks_msec()

	_test_resource_loading()
	_test_scene_loading()
	_test_asset_validation()
	_test_stats_component()
	_test_combat_component()
	_test_performance()

	_write_results()
	var failed := _results.filter(func(r: Dictionary) -> bool: return r.status == "fail").size()
	get_tree().quit(1 if failed > 0 else 0)


# ── Assertion helpers ──────────────────────────────────────────────

func _assert_true(condition: bool, test_name: String, message: String = "") -> void:
	_results.append({
		"name": test_name,
		"status": "pass" if condition else "fail",
		"message": "" if condition else (message if message else "Expected true, got false"),
	})


func _assert_eq(actual: Variant, expected: Variant, test_name: String, message: String = "") -> void:
	var passed := actual == expected
	_results.append({
		"name": test_name,
		"status": "pass" if passed else "fail",
		"message": "" if passed else (message if message else "Expected %s, got %s" % [str(expected), str(actual)]),
	})


func _assert_not_null(value: Variant, test_name: String, message: String = "") -> void:
	var passed := value != null
	_results.append({
		"name": test_name,
		"status": "pass" if passed else "fail",
		"message": "" if passed else (message if message else "Expected non-null value"),
	})


# ── A. Resource Loading (6 tests) ─────────────────────────────────

func _test_resource_loading() -> void:
	var abilities := [
		"rising_blade", "fire_bolt", "ice_arc",
		"wind_step", "lightning_thrust", "guardian_rune",
	]
	for ability_name in abilities:
		var path := "res://data/abilities/%s.tres" % ability_name
		var res := load(path)
		if res == null:
			_assert_true(false, "resource_load_%s" % ability_name, "Failed to load %s" % path)
			continue
		var valid := res is AbilityData and res.ability_name != &"" and res.mp_cost > 0 and res.cooldown > 0 and res.damage > 0
		_assert_true(valid, "resource_load_%s" % ability_name,
			"Invalid AbilityData fields for %s" % ability_name if not valid else "")


# ── B. Scene Loading (8 tests) ────────────────────────────────────

func _test_scene_loading() -> void:
	var scenes := {
		"main_menu": "res://src/ui/menus/main_menu.tscn",
		"test_arena": "res://src/world/test_arena.tscn",
		"player": "res://src/player/player.tscn",
		"camera_rig": "res://src/camera/camera_rig.tscn",
		"hud": "res://src/ui/hud/hud.tscn",
		"enemy_base": "res://src/enemies/enemy_base.tscn",
		"test_dummy": "res://src/enemies/test_dummy/test_dummy.tscn",
		"pause_menu": "res://src/ui/menus/pause_menu.tscn",
	}
	for scene_name in scenes:
		var path: String = scenes[scene_name]
		var packed: PackedScene = load(path)
		if packed == null:
			_assert_true(false, "scene_load_%s" % scene_name, "Failed to load %s" % path)
			continue
		var instance := packed.instantiate()
		var success := instance != null
		_assert_true(success, "scene_load_%s" % scene_name,
			"Failed to instantiate %s" % path if not success else "")
		if instance:
			instance.free()


# ── C. Asset Validation (4 tests) ─────────────────────────────────

func _test_asset_validation() -> void:
	# C1: Autoload scripts exist
	var autoloads := [
		"res://src/autoloads/events.gd",
		"res://src/autoloads/game_manager.gd",
		"res://src/autoloads/input_manager.gd",
		"res://src/autoloads/audio_manager.gd",
	]
	var all_exist := true
	var missing: Array[String] = []
	for path in autoloads:
		if not FileAccess.file_exists(path):
			all_exist = false
			missing.append(path)
	_assert_true(all_exist, "asset_autoload_scripts",
		"Missing: %s" % ", ".join(missing) if not all_exist else "")

	# C2: player_stats.tres loads with valid values
	var stats_res := load("res://data/player_stats.tres")
	var stats_valid := stats_res != null and stats_res is PlayerStatsData and stats_res.max_hp > 0 and stats_res.max_mp > 0
	_assert_true(stats_valid, "asset_player_stats",
		"player_stats.tres missing or invalid" if not stats_valid else "")

	# C3: Collision layer names configured
	var layer_count := 0
	for i in range(1, 9):
		var setting_key := "layer_names/3d_physics/layer_%d" % i
		var name_val: String = ProjectSettings.get_setting(setting_key, "")
		if name_val != "":
			layer_count += 1
	_assert_eq(layer_count, 8, "asset_collision_layers",
		"Expected 8 collision layer names, found %d" % layer_count)

	# C4: Input actions registered
	var expected_actions := [
		"move_forward", "move_back", "move_left", "move_right",
		"jump", "dodge", "sprint", "attack", "heavy_attack",
		"lock_on_toggle", "lock_on_switch_left", "lock_on_switch_right",
		"tactical_mode", "ability_1", "ability_2", "ability_3",
		"ability_4", "ability_5", "ability_6",
		"camera_rotate_left", "camera_rotate_right", "pause",
	]
	var missing_actions: Array[String] = []
	for action in expected_actions:
		if not InputMap.has_action(action):
			missing_actions.append(action)
	_assert_true(missing_actions.is_empty(), "asset_input_actions",
		"Missing actions: %s" % ", ".join(missing_actions) if not missing_actions.is_empty() else "")


# ── D. StatsComponent Logic (4 tests) ─────────────────────────────

func _test_stats_component() -> void:
	# Build a parent chain so take_damage()'s get_parent().get_parent() works
	var grandparent := Node3D.new()
	var parent_node := Node.new()
	var stats := StatsComponent.new()
	grandparent.add_child(parent_node)
	parent_node.add_child(stats)
	# Set values directly — _ready() hasn't fired since not in scene tree
	stats.max_hp = 100.0
	stats.current_hp = 100.0
	stats.max_mp = 50.0
	stats.current_mp = 50.0

	# D1: spend_mp — false when insufficient, true + decrement when sufficient
	var spend_fail := stats.spend_mp(60.0)
	var mp_after_fail := stats.current_mp
	var spend_ok := stats.spend_mp(30.0)
	var mp_after_ok := stats.current_mp
	_assert_true(
		not spend_fail and mp_after_fail == 50.0 and spend_ok and mp_after_ok == 20.0,
		"stats_spend_mp",
		"spend_mp(60) should fail (mp=50), spend_mp(30) should succeed and decrement to 20",
	)

	# D2: has_mp boundary — exact amount = true, one over = false
	stats.current_mp = 25.0
	var has_exact := stats.has_mp(25.0)
	var has_over := stats.has_mp(25.1)
	_assert_true(has_exact and not has_over, "stats_has_mp_boundary",
		"has_mp(25.0) should be true, has_mp(25.1) should be false when mp=25.0")

	# D3: take_damage clamps HP to 0
	stats.current_hp = 30.0
	stats.take_damage(50.0)
	_assert_eq(stats.current_hp, 0.0, "stats_take_damage_clamp",
		"HP should clamp to 0, got %s" % str(stats.current_hp))

	# D4: heal clamps HP to max_hp
	stats.current_hp = 80.0
	stats.heal(50.0)
	_assert_eq(stats.current_hp, 100.0, "stats_heal_clamp",
		"HP should clamp to max_hp (100), got %s" % str(stats.current_hp))

	grandparent.free()


# ── E. CombatComponent Logic (2 tests) ────────────────────────────

func _test_combat_component() -> void:
	var combat := CombatComponent.new()

	# E1: calculate_damage
	_assert_eq(combat.calculate_damage(10.0, 1.5), 15.0, "combat_calculate_damage",
		"calculate_damage(10, 1.5) should equal 15.0")

	# E2: get_max_combo with null combo_data
	_assert_eq(combat.get_max_combo(), 0, "combat_max_combo_null",
		"get_max_combo() should return 0 when combo_data is null")

	combat.free()


# ── F. Performance Sanity (1 test) ────────────────────────────────

func _test_performance() -> void:
	var scenes := [
		"res://src/ui/menus/main_menu.tscn",
		"res://src/world/test_arena.tscn",
		"res://src/player/player.tscn",
		"res://src/camera/camera_rig.tscn",
		"res://src/ui/hud/hud.tscn",
		"res://src/enemies/enemy_base.tscn",
		"res://src/enemies/test_dummy/test_dummy.tscn",
		"res://src/ui/menus/pause_menu.tscn",
	]
	var perf_start := Time.get_ticks_msec()
	for path in scenes:
		var packed: PackedScene = load(path)
		if packed:
			var inst := packed.instantiate()
			if inst:
				inst.free()
	var elapsed := Time.get_ticks_msec() - perf_start
	_assert_true(elapsed < 5000, "perf_scene_loading",
		"Scene loading took %dms (limit: 5000ms)" % elapsed)


# ── Results output ─────────────────────────────────────────────────

func _write_results() -> void:
	var duration := Time.get_ticks_msec() - _start_time
	var passed := _results.filter(func(r: Dictionary) -> bool: return r.status == "pass").size()
	var total := _results.size()

	var output := {
		"status": "pass" if passed == total else "fail",
		"testsTotal": total,
		"testsPassed": passed,
		"durationMs": duration,
		"timestamp": Time.get_datetime_string_from_system(true) + "Z",
		"details": _results,
	}

	var json_string := JSON.stringify(output, "  ")

	# Write to project tests/ directory
	var output_path := ProjectSettings.globalize_path("res://tests/test-results.json")
	var file := FileAccess.open(output_path, FileAccess.WRITE)
	if file:
		file.store_string(json_string)
		file.close()

	# Also print to stdout
	print(json_string)
