extends Node

class_name Game

enum CountdownState {
	COUNTDOWN,
	COUNTUP
}

signal countdown_updated(new_timer: int)
signal countdown_state_changed(countdown_state: CountdownState)
signal next_stage(stage: int)

static var instance: Game = null

@export var world: World
@export var player_component: Entity
@export
var chill_audio_stream_player: AudioStreamPlayer
@export
var intense_audio_stream_player: AudioStreamPlayer
var countdown_state: CountdownState = CountdownState.COUNTUP
var timer: int = 0
var stage: int = 1
var difficulty_factor: float = 1.0

var chill_music: Array[AudioStreamWAV] = [
	preload("res://assets/music/Epic - Ascension.wav"),
	preload("res://assets/music/Epic - Coalition.wav"),
	preload("res://assets/music/Epic - Ganesha.wav"),
	preload("res://assets/music/Epic - Payback.wav"),
]
var intense_music: Array[AudioStreamWAV] = [
	preload("res://assets/music/Epic - Brave.wav"),
	preload("res://assets/music/Epic - Energy.wav"),
	preload("res://assets/music/Epic - Opps.wav"),
	preload("res://assets/music/Epic - Ship.wav"),
]

func _init() -> void:
	Engine.time_scale = 1.0
	instance = self

func _ready() -> void:
	player_component.entity_component.death.connect(_on_player_death)
	next_stage.emit(stage)
	change_countdown_state(CountdownState.COUNTUP)

func _physics_process(delta: float) -> void:
	if (countdown_state == CountdownState.COUNTUP):
		timer += floor(delta * 1000)
		countdown_updated.emit(timer)
		if (timer >= 180000):
			trigger_showdown()
	else:
		timer -= max(0, floor(delta * 1000))
		countdown_updated.emit(timer)		
		if (timer <= 0):
			stage += 1
			difficulty_factor = (0.6 + float(stage) * 0.4)
			next_stage.emit(stage)
			change_countdown_state(CountdownState.COUNTUP)

func trigger_showdown() -> void:
	change_countdown_state(CountdownState.COUNTDOWN)

func change_countdown_state(new_state: CountdownState) -> void:
	countdown_state = new_state
	new_music()
	countdown_state_changed.emit(new_state)

func new_music() -> void:
	match countdown_state:
		CountdownState.COUNTUP:
			chill_audio_stream_player.play()
			var tween: Tween = get_tree().create_tween()
			tween.tween_property(intense_audio_stream_player, "volume_db", -30, 3)
			var tween2: Tween = get_tree().create_tween()
			tween2.tween_property(chill_audio_stream_player, "volume_db", 0, 3)
			tween.finished.connect(func(): intense_audio_stream_player.stop())
			chill_audio_stream_player.stream = chill_music[randi_range(0, chill_music.size() - 1)]
			chill_audio_stream_player.play()
		CountdownState.COUNTDOWN:
			intense_audio_stream_player.play()
			var tween: Tween = get_tree().create_tween()
			tween.tween_property(chill_audio_stream_player, "volume_db", -30, 3)
			var tween2: Tween = get_tree().create_tween()
			tween2.tween_property(intense_audio_stream_player, "volume_db", 0, 2)
			tween.finished.connect(func(): chill_audio_stream_player.stop())
			intense_audio_stream_player.stream = intense_music[randi_range(0, intense_music.size() - 1)]
			intense_audio_stream_player.play()

func _on_player_death() -> void:
	Engine.time_scale = 0.0

func restart_game() -> void:
	get_tree().reload_current_scene()
