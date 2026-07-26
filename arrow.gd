extends Node2D

class_name Arrow

signal target_hit(target: Harvestable)

@export var hitbox: Area2D
@export var speed: float = 60.0
@export var pierce_count: int

var direction: Vector2:
	set(value):
		direction = value.normalized()

var shooter: Entity
var _hits_left: int

func _ready() -> void:
	_hits_left = pierce_count
	hitbox.body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if body == shooter:
		return

	var registered_hit: bool = false

	if body is Entity:
		for child in body.get_children():
			if child is Harvestable:
				target_hit.emit(child)
				registered_hit = true
	elif body is GameCollision:
		for child in body.get_parent().get_children():
			if child is Harvestable:
				target_hit.emit(child)
				registered_hit = true

	if registered_hit:
		_hits_left -= 1
		if _hits_left <= 0:
			queue_free()

func _physics_process(delta: float) -> void:
	position += direction * speed * delta