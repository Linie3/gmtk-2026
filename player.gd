extends EntityComponent

class_name Player

signal death()

@export
var speed: float = 30.0
@export
var items: ItemInventory
@export
var resource_inventory: ResourceInventory
@export
var entity_component: CharacterBody2D
@export
var harvestable: Harvestable

func _ready() -> void:
	harvestable.harvestable_depleted.connect(func() -> void: death.emit())

func _physics_process(delta: float) -> void:
	var direction: Vector2 = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	entity_component.velocity = direction * speed
	entity_component.move_and_slide()

func _process(delta: float) -> void:
	if (Input.is_action_pressed("use_item")):
		items.use_active_item(entity_component.get_global_mouse_position() - entity_component.global_position)
