extends Node2D

class_name Splinter

signal target_hit(target: Harvestable)

@export
var hitbox: Harvester
@export
var speed: float = 60.0
@export
var lifetimer: Timer
var direction: Vector2:
	set(value):
		direction = value.normalized()
var shooter: Entity

func _ready() -> void:
	hitbox.harvest.connect(func(a, b) -> void: queue_free())
	hitbox.start_harvesting()
	lifetimer.timeout.connect(queue_free)

func _physics_process(delta: float) -> void:
	position += direction * speed * delta
