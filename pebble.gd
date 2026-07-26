extends Node2D

class_name Pebble

signal target_hit(target: Harvestable)

@export
var hitbox: Area2D
@export
var speed: float = 60.0
var direction: Vector2:
	set(value):
		direction = value.normalized()
var shooter: Entity

func _ready() -> void:
	hitbox.body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if body == shooter:
		return
	if body is Entity:
		for child in body.get_children():
			if child is Harvestable:
				target_hit.emit(child)
	elif body is GameCollision:
		for child in body.get_parent().get_children():
			if child is Harvestable:
				target_hit.emit(child)
	queue_free()

func _physics_process(delta: float) -> void:
	position += direction * speed * delta
