extends Node

const ITEMS_PATH: String = "res://item/items/"
const ICON_LOCATION: String = "res://assets/items/icons/"

var items: Dictionary[StringName, PackedScene]

func _init() -> void:
	for item_location in Global.get_files_in_directory(ITEMS_PATH, "tscn", "PackedScene"):
		items[item_location] = load(ITEMS_PATH + item_location)

func get_item_types() -> Array[StringName]:
	return items.keys()
	
func get_item_icon(item_name: StringName) -> CompressedTexture2D:
	return load(ICON_LOCATION + item_name.to_lower() + ".png")

func create_item(item_name: StringName) -> Item:
	return items[item_name].instantiate()
