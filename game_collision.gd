extends StaticBody2D

var world: World

func _enter_tree() -> void:
	world = World.instance
	world.schedule_navigation_update()

func _exit_tree() -> void:
	world.schedule_navigation_update()