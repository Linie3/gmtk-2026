extends Node2D

class_name Arrow

signal target_hit(target: Harvestable)

@export var hitbox: Harvester
@export var speed: float = 60.0
@export var pierce_count: int

var direction: Vector2:
	set(value):
		direction = value.normalized()

var shooter: Entity
var _hits_left: int

func _ready() -> void:
	_hits_left = pierce_count
	hitbox.harvest.connect(_on_body_entered)
	hitbox.start_harvesting()

func _on_body_entered(a, b) -> void:
	_hits_left -= 1
	if _hits_left <= 0:
		queue_free()

func _physics_process(delta: float) -> void:
	position += direction * speed * delta
