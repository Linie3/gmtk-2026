extends Node2D

static var counter: int = 0:
	set(value):
		counter = value
		if value > 0:
			Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)
		else:
			Input.set_default_cursor_shape(Input.CURSOR_ARROW)
			

@export
var collision_node: Area2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	collision_node.mouse_entered.connect(_on_mouse_entered)
	collision_node.mouse_exited.connect(_on_mouse_exited)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_mouse_entered() -> void:
	counter += 1

func _on_mouse_exited() -> void:
	counter -= 1
	
