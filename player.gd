extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

@export var speed: float = 300.0

func _physics_process(delta: float) -> void:
	print("here")
	var direction: Vector2 = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	print(direction)
	position += direction * speed
