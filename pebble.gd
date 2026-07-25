extends Node2D

class_name Pebble

signal target_hit(target: Node2D)

@export
var hitbox: Area2D
@export
var speed: float = 60.0
var direction: Vector2:
	set(value):
		direction = value.normalized()

func _ready() -> void:
	hitbox.body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	target_hit.emit(body)
	#queue_free()

func _physics_process(delta: float) -> void:
	position += direction * speed * delta
