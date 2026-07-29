extends Node

enum ResourceType {
	WOOD,
	STONE,
}

var resource_icons: Dictionary[ResourceType, CompressedTexture2D] = {}

func _ready() -> void:
	for resource_type in ResourceType.values():
		resource_icons[resource_type] = load("res://assets/game_resources/" + ResourceType.keys()[resource_type].to_lower() + ".png")

func get_resource_types() -> Array[ResourceType]:
	return ResourceType.values()

func get_resource_name(resource_type: ResourceType) -> String:
	return ResourceType.keys()[resource_type]

func get_resource_icon(resource_type: ResourceType) -> CompressedTexture2D:
	return resource_icons[resource_type]
