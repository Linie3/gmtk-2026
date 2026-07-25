extends Node2D

class_name Item

signal harvest(resources: Dictionary[GameResource.ResourceType, int])

@export
var cooldown: float = 1.0
@export
var usage_cost: Dictionary[GameResource.ResourceType, int] = {}

func use(target_direction: Vector2) -> void:
	pass