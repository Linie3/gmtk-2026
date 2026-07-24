extends Node2D

const tree = preload("res://tree.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for position in get_random_positions(10, Rect2(Vector2(0, 0), Vector2(1000, 1000))):
		var new_tree : Node2D = tree.instantiate()
		new_tree.position = position
		add_child(new_tree)

func get_random_positions(amount: int, area: Rect2) -> Array[Vector2]:
	var positions: Array[Vector2] = []
	var rng := RandomNumberGenerator.new()
	rng.randomize()

	for i in amount:
		var pos := Vector2(
			rng.randf_range(area.position.x, area.end.x),
			rng.randf_range(area.position.y, area.end.y)
		)
		positions.append(pos)

	return positions
