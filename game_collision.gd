extends StaticBody2D

class_name GameCollision

var world: World

func _enter_tree() -> void:
	world = World.instance
	world.schedule_navigation_update()

func _exit_tree() -> void:
	world.schedule_navigation_update()