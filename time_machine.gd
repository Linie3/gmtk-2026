extends Node2D

class_name TimeMachine

@export
var interaction_button: Control
@export
var popup: Control
@export
var interactable: Interactable
@export
var resources_container: Control
@export
var player_component: Entity
@export
var base_cost: int = 10
var resource_container_scene: PackedScene = preload("res://resource_container.tscn")
var player_in_range: bool = false
var repair_cost: Dictionary[GameResource.ResourceType, int] = {}
var resource_inventory: ResourceInventory

func _ready() -> void:
	resource_inventory = player_component.entity_component.resource_inventory
	resource_inventory.resource_changed.connect(_on_resource_changed)
	interaction_button.visible = false
	interactable.interacter_entered_range.connect(_on_interacter_entered_range)
	interactable.interacter_left_range.connect(_on_interacter_left_range)
	interactable.interacted.connect(_on_interacted)
	Game.instance.countdown_state_changed.connect(_on_countdown_state_changed)
	generate_repair_cost(base_cost)

func _on_interacted() -> void:
	if can_activate():
		resource_inventory.remove_resources(repair_cost)
		Game.instance.trigger_showdown()

func _on_interacter_entered_range(interacter: Interacter) -> void:
	if (interacter.get_parent() is Entity && interacter.get_parent().entity_component is Player):
		player_in_range = true
		_update_button_state()

func _on_interacter_left_range(interacter: Interacter) -> void:
	if (interacter.get_parent() is Entity && interacter.get_parent().entity_component is Player):
		player_in_range = false
		_update_button_state()

func _update_button_state() -> void:
	interaction_button.visible = can_activate()

func can_activate() -> bool:
	return player_in_range and Game.instance.countdown_state == Game.CountdownState.COUNTUP and resource_inventory.has_resources(repair_cost)

func generate_repair_cost(amount: int) -> void:
	for child in resources_container.get_children():
		child.queue_free()

	repair_cost.clear()
	var available_resources: Array = GameResource.get_resource_types()
	var base_share: int = amount / available_resources.size()
	var remainder: int = amount % available_resources.size()
	
	for i in available_resources.size():
		var type = available_resources[i]
		var cost_for_type: int = base_share + (1 if i < remainder else 0)
		
		if cost_for_type > 0:
			repair_cost[type] = cost_for_type
	
	for resource_type in repair_cost.keys():
		var container: ResourceContainer = resource_container_scene.instantiate()
		container.set_resource(resource_type, repair_cost[resource_type])
		container.content_size = 32
		container.insufficient_resources = resource_inventory.get_resource_amount(resource_type) < repair_cost[resource_type]
		resources_container.add_child(container)
		
func _on_resource_changed(resource_type: GameResource.ResourceType, amount: int) -> void:
	if repair_cost.has(resource_type):
		resources_container.get_child(resource_type).insufficient_resources = amount < repair_cost[resource_type]

func _on_countdown_state_changed(new_state: Game.CountdownState) -> void:
	_update_button_state()
	if new_state == Game.CountdownState.COUNTUP:
		popup.visible = true
		generate_repair_cost(round(float(base_cost) * Game.instance.difficulty_factor))
	else:
		popup.visible = false
