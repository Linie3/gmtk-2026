extends Node2D

class_name Item

static var ICON_LOCATION: String = "res://assets/items/icons/"
static func get_item_icon(item_name: StringName) -> CompressedTexture2D:
	return load(ICON_LOCATION + item_name.to_lower() + ".png")

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
