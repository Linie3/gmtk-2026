extends Node2D

class_name World

static var instance: World
static func add_object(object: Node2D) -> void:
	instance._add_object(object)

const tree: PackedScene = preload("res://tree.tscn")
const rock: PackedScene = preload("res://rock.tscn")
@export var navigation_region: NavigationRegion2D
@export
var objects_container: Node2D

func _ready() -> void:
	instance = self
	for position in get_random_positions(15, Rect2(Vector2(-1000, -1000), Vector2(2000, 2000))):
		var new_tree : Node2D = tree.instantiate()
		new_tree.position = position
		_add_object(new_tree)
	for position in get_random_positions(9, Rect2(Vector2(-1000, -1000), Vector2(2000, 2000))):
		var new_rock : Node2D = rock.instantiate()
		new_rock.position = position
		_add_object(new_rock)
	navigation_region.bake_navigation_polygon()

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

func _add_object(object: Node2D) -> void:
	objects_container.add_child(object)
