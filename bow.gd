extends Item

const arrow_scene: PackedScene = preload("res://arrow.tscn")

func use(target_direction: Vector2) -> void:
	var new_arrow: Arrow = arrow_scene.instantiate()
	new_arrow.position = global_position
	new_arrow.direction = target_direction
	new_arrow.rotation = target_direction.angle()
	new_arrow.shooter = entity
	new_arrow.target_hit.connect(_on_target_hit)
	World.add_object(new_arrow)

func _on_target_hit(target: Harvestable) -> void:
	target.harvest(3)
