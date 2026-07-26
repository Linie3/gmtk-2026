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
var countdown_state: CountdownState = CountdownState.COUNTUP
var timer: int = 0

func _init() -> void:
	instance = self

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
