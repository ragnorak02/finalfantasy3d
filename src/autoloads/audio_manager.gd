extends Node

const SFX_POOL_SIZE := 8
const MUSIC_FADE_DURATION := 1.0

var _sfx_players: Array[AudioStreamPlayer] = []
var _sfx_index: int = 0
var _music_player: AudioStreamPlayer
var _music_player_fade: AudioStreamPlayer

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS

	for i in SFX_POOL_SIZE:
		var player := AudioStreamPlayer.new()
		player.bus = &"SFX"
		add_child(player)
		_sfx_players.append(player)

	_music_player = AudioStreamPlayer.new()
	_music_player.bus = &"Music"
	add_child(_music_player)

	_music_player_fade = AudioStreamPlayer.new()
	_music_player_fade.bus = &"Music"
	add_child(_music_player_fade)

	# Wire up game events to audio
	Events.ability_cast_started.connect(_on_ability_cast_started)
	Events.damage_dealt.connect(_on_damage_dealt)
	Events.ability_cast_failed_no_mp.connect(_on_ability_failed)
	Events.player_state_changed.connect(_on_player_state_changed)

func _on_ability_cast_started(ability: AbilityData) -> void:
	if ability and ability.sfx_cast:
		play_sfx(ability.sfx_cast)

func _on_damage_dealt(_target: Node3D, _amount: float, _source: Node3D) -> void:
	# Play a generic hit sound; specific impact SFX can be set per ability
	pass

func _on_ability_failed(_ability: AbilityData) -> void:
	# Play MP fail buzzer when audio assets are added
	pass

func _on_player_state_changed(_old_state: StringName, new_state: StringName) -> void:
	if new_state == &"Dodge":
		# Play dodge whoosh when audio assets are added
		pass

func play_sfx(stream: AudioStream, volume_db: float = 0.0, pitch_scale: float = 1.0) -> void:
	if stream == null:
		return
	var player := _sfx_players[_sfx_index]
	player.stream = stream
	player.volume_db = volume_db
	player.pitch_scale = pitch_scale
	player.play()
	_sfx_index = (_sfx_index + 1) % SFX_POOL_SIZE

func play_music(stream: AudioStream, fade_in: bool = true) -> void:
	if stream == null:
		return
	if _music_player.playing and fade_in:
		_crossfade_music(stream)
	else:
		_music_player.stream = stream
		_music_player.play()

func stop_music(fade_out: bool = true) -> void:
	if fade_out and _music_player.playing:
		var tween := create_tween()
		tween.tween_property(_music_player, "volume_db", -40.0, MUSIC_FADE_DURATION)
		tween.tween_callback(_music_player.stop)
		tween.tween_property(_music_player, "volume_db", 0.0, 0.0)
	else:
		_music_player.stop()

func _crossfade_music(new_stream: AudioStream) -> void:
	_music_player_fade.stream = _music_player.stream
	_music_player_fade.volume_db = _music_player.volume_db
	_music_player_fade.play(_music_player.get_playback_position())

	_music_player.stream = new_stream
	_music_player.volume_db = -40.0
	_music_player.play()

	var tween := create_tween()
	tween.set_parallel(true)
	tween.tween_property(_music_player, "volume_db", 0.0, MUSIC_FADE_DURATION)
	tween.tween_property(_music_player_fade, "volume_db", -40.0, MUSIC_FADE_DURATION)
	tween.set_parallel(false)
	tween.tween_callback(_music_player_fade.stop)
