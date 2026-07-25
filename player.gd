extends CharacterBody2D

@export var speed: float = 30.0
@export var items: ItemInventory

func _physics_process(delta: float) -> void:
	var direction: Vector2 = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = direction * speed
	move_and_slide()

func _process(delta: float) -> void:
	if (Input.is_action_pressed("use_item") && items.active_item != null && items.active_item_cooldown_finished):
		items.active_item.use(get_global_mouse_position() - global_position)
		items.start_item_cooldown()
