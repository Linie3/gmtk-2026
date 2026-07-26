extends Item

const pebble_scene: PackedScene = preload("res://pebble.tscn")

func use(target_direction: Vector2) -> void:
	var new_pebble: Pebble = pebble_scene.instantiate()
	new_pebble.position = global_position
	new_pebble.direction = target_direction
	new_pebble.rotation = target_direction.angle()
	new_pebble.shooter = entity
	new_pebble.target_hit.connect(_on_target_hit)
	World.add_object(new_pebble)

func _on_target_hit(target: Harvestable) -> void:
	target.harvest(1)
