extends Node

class_name Game

signal timer_updated(new_timer: int)

static var instance: Game = null

static func start_wave() -> void:
	instance.wave_started = true

@export var world: World
var wave_started: bool = false
var timer: int = 0

func _ready() -> void:
	instance = self

func _physics_process(delta: float) -> void:
	if (!wave_started):
		timer += floor(delta * 1000)
		timer_updated.emit(timer)
	else:
		timer -= floor(delta * 1000)
		timer_updated.emit(timer)		
