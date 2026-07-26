extends Node

class_name Game

enum CountdownState {
	COUNTDOWN,
	COUNTUP
}

signal countdown_updated(new_timer: int)
signal countdown_state_changed(countdown_state: CountdownState)

static var instance: Game = null

@export var world: World
@export var player_component: Entity
var countdown_state: CountdownState = CountdownState.COUNTUP
var timer: int = 0

func _init() -> void:
	Engine.time_scale = 1.0
	instance = self

func _ready() -> void:
	player_component.entity_component.death.connect(_on_player_death)

func _physics_process(delta: float) -> void:
	if (countdown_state == CountdownState.COUNTUP):
		timer += floor(delta * 1000)
		countdown_updated.emit(timer)
	else:
		timer -= max(0, floor(delta * 1000))
		countdown_updated.emit(timer)		
		if (timer <= 0):
			change_countdown_state(CountdownState.COUNTUP)

func change_countdown_state(new_state: CountdownState) -> void:
	countdown_state = new_state
	countdown_state_changed.emit(new_state)

func _on_player_death() -> void:
	Engine.time_scale = 0.0

func start_game() -> void:
	get_tree().reload_current_scene()
