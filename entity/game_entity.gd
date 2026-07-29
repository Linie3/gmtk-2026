extends Node

const ENTITIES_PATH: String = "res://entity/entities/"

var entities: Dictionary[StringName, EntityData]
var entity_locations: Dictionary[StringName, String]

func _init() -> void:
	var loaded_data: Dictionary[StringName, EntityData] = Global.load_directory(ENTITIES_PATH, "res")
	for entity_locaction: StringName in loaded_data.keys():
		var entity_data: EntityData = loaded_data[entity_locaction]
		entity_locations[entity_data.name] = entity_locaction
		entities[entity_data.name] = entity_data

func get_entity(entity_name: StringName) -> Entity:
	if !entities.has(entity_name):
		push_error("Entity " + entity_name + " not found")
		return
	var entity_location: String = entity_locations[entity_name]
	var entity: Entity = load(ENTITIES_PATH + entity_location + "/" + entity_location + ".tscn").instantiate()
	entity.entity_name = entity_name
	entity.display_name = entities[entity_name].display_name
	entity.entity_type = entities[entity_name].type
	return entity