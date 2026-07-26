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
var audio_stream_player: AudioStreamPlayer
var countdown_state: CountdownState = CountdownState.COUNTUP
var timer: int = 0
var stage: int = 1
var difficulty_factor: float = 1.0

var music: Array[AudioStreamWAV] = [
	preload("res://assets/music/Epic - Ascension.wav"),
	preload("res://assets/music/Epic - Brave.wav"),
	preload("res://assets/music/Epic - Coalition.wav"),
	preload("res://assets/music/Epic - Energy.wav"),
	preload("res://assets/music/Epic - Ganesha.wav"),
	preload("res://assets/music/Epic - Opps.wav"),
	preload("res://assets/music/Epic - Payback.wav"),
	preload("res://assets/music/Epic - Ship.wav"),
]

func _init() -> void:
	Engine.time_scale = 1.0
	instance = self

func _ready() -> void:
	player_component.entity_component.death.connect(_on_player_death)
	next_stage.emit(stage)
	music.shuffle()
	_on_audio_finished()
var audio_index: int = -1

func _on_audio_finished() -> void:
	audio_stream_player.stream = music[audio_index]
	audio_stream_player.play()
	audio_index = (audio_index + 1) % len(music)
	
func _physics_process(delta: float) -> void:
	if (countdown_state == CountdownState.COUNTUP):
		timer += floor(delta * 1000)
		countdown_updated.emit(timer)
	else:
		timer -= max(0, floor(delta * 1000))
		countdown_updated.emit(timer)		
		if (timer <= 0):
			stage += 1
			difficulty_factor = (0.6 + float(stage) * 0.4)
			next_stage.emit(stage)
			change_countdown_state(CountdownState.COUNTUP)

func trigger_showdown() -> void:
	_on_audio_finished()
	change_countdown_state(CountdownState.COUNTDOWN)

func change_countdown_state(new_state: CountdownState) -> void:
	countdown_state = new_state
	countdown_state_changed.emit(new_state)

func _on_player_death() -> void:
	Engine.time_scale = 0.0

func restart_game() -> void:
	get_tree().reload_current_scene()
