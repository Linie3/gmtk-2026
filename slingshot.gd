extends Item

const pebble_scene: PackedScene = preload("res://pebble.tscn")

func use(target_direction: Vector2) -> void:
	var new_pebble: Pebble = pebble_scene.instantiate()
	new_pebble.position = global_position
	new_pebble.direction = target_direction
	new_pebble.rotation = target_direction.angle()
	World.add_object(new_pebble)
