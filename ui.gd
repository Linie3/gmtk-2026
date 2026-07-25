extends Control

@export var game: Game
@export var timer: Label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	game.timer_updated.connect(_on_timer_updated)

func _on_timer_updated(new_timer: int) -> void:
	var total_seconds: float = new_timer / 1000.0
	var minutes: int = int(total_seconds) / 60
	var seconds: float = fmod(total_seconds, 60.0)
	timer.text = "Time: %02d:%04.1f" % [minutes, seconds]
