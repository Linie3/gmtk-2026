extends Node

class_name ResourceInventory

signal resource_changed(resource_type: GameResource.ResourceType, amount: int)

var resources: Dictionary[GameResource.ResourceType, int]

func _ready() -> void:
	for resource_type in GameResource.get_resource_types():
		resources[resource_type] = 0

func add_resource(resource_type: GameResource.ResourceType, amount: int) -> void:
	resources[resource_type] += amount
	resource_changed.emit(resource_type, resources[resource_type])

func add_resources(new_resources: Dictionary[GameResource.ResourceType, int]) -> void:
	for resource_type in new_resources.keys():
		add_resource(resource_type, new_resources[resource_type])

func remove_resource(resource_type: GameResource.ResourceType, amount: int) -> void:
	resources[resource_type] -= amount
	resource_changed.emit(resource_type, resources[resource_type])

func remove_resources(old_resources: Dictionary[GameResource.ResourceType, int]) -> void:
	for resource_type in old_resources.keys():
		remove_resource(resource_type, old_resources[resource_type])

func has_resources(required_resources: Dictionary[GameResource.ResourceType, int]) -> bool:
	for resource_type in required_resources.keys():
		if (resources[resource_type] < required_resources[resource_type]):
			return false
	return true

func get_resource_amount(resource_type: GameResource.ResourceType) -> int:
	return resources[resource_type] if resources.has(resource_type) else 0 
