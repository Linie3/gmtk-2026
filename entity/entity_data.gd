extends Resource

class_name EntityData

enum EntityType {
	PLAYER,
	ENEMY,
	ENVIRONMENT,
}

@export
var name: StringName
@export
var display_name: String
@export
var type: EntityType