extends Node2D

class_name Item

signal harvest(resources: Dictionary[GameResource.ResourceType, int])

var entity: Entity

@export
var item_name: StringName
@export
var cooldown: float = 1.0
@export
var usage_cost: Dictionary[GameResource.ResourceType, int] = {}
@export
var repair_cost: Dictionary[GameResource.ResourceType, int] = {}

func use(target_direction: Vector2) -> void:
	pass
