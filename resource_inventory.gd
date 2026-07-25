extends Node

class_name ResourceInventory

signal resource_changed(resource_type: GameResource.ResourceType, amount: int)

var resources: Dictionary[GameResource.ResourceType, int]

func _ready() -> void:
	for resource_type in GameResource.get_resource_types():
		resources[resource_type] = 0

func add_resources(resource_type: GameResource.ResourceType, amount: int) -> void:
	resources[resource_type] += amount
	resource_changed.emit(resource_type, resources[resource_type])

func get_resource_amount(resource_type: GameResource.ResourceType) -> int:
	return resources[resource_type]
