extends Item

const splinter_scene: PackedScene = preload("res://splinter.tscn")

@export
var splinter_count: int
@export_range(0.0, 180.0)
var spread_degrees: float = 25.0

func use(target_direction: Vector2) -> void:
	var base_angle: float = target_direction.angle()
	var spread_radians: float = deg_to_rad(spread_degrees)

	for i in splinter_count:
		var new_splinter: Splinter = splinter_scene.instantiate()
		new_splinter.position = global_position
		
		var random_offset: float = randf_range(-spread_radians / 2.0, spread_radians / 2.0)
		var final_angle: float = base_angle + random_offset
		var final_direction: Vector2 = Vector2.RIGHT.rotated(final_angle)

		new_splinter.direction = final_direction
		new_splinter.rotation = final_angle
		new_splinter.shooter = entity
		new_splinter.target_hit.connect(_on_target_hit)
		
		World.add_object(new_splinter)

func _on_target_hit(target: Harvestable) -> void:
	target.harvest(1)
