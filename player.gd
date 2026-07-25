extends CharacterBody2D

class_name Player

@export var speed: float = 30.0
@export var items: ItemInventory
@export
var resource_inventory: ResourceInventory

func _physics_process(delta: float) -> void:
	var direction: Vector2 = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = direction * speed
	move_and_slide()

func _process(delta: float) -> void:
	if (Input.is_action_pressed("use_item")):
		items.use_active_item(get_global_mouse_position() - global_position)
