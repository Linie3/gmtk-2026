extends Node

class_name Game

signal timer_updated(new_timer: int)

@export var world: World
var timer: int = 0

func _physics_process(delta: float) -> void:
	timer += floor(delta * 1000)
	timer_updated.emit(timer)
