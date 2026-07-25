extends Node2D

class_name ItemInventory

@export
var item_cooldown: Timer
@export
var items_container: Node2D
@export
var resource_inventory: ResourceInventory
var active_item: Item
var active_item_cooldown_finished: bool = true
var items: Array[Item] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	item_cooldown.timeout.connect(func(): active_item_cooldown_finished = true)
	for child in items_container.get_children():
		if (child is Item):
			add_item(child)

func start_item_cooldown() -> void:
	assert(active_item_cooldown_finished, "Cannot start item cooldown when one is already active")
	active_item_cooldown_finished = false
	item_cooldown.wait_time = active_item.cooldown
	item_cooldown.start()

func add_item(item: Item) -> void:
	items.append(item)
	if (!active_item):
		_set_active_item(item)
	item.harvest.connect(_on_item_harvest)

func remove_item(item: Item) -> void:
	item.harvest.disconnect(_on_item_harvest)
	if (active_item == item):
		# Todo Handle next active item
		_set_active_item(null)
	items.erase(item)

func use_active_item(direction: Vector2) -> void:
	if (active_item && active_item_cooldown_finished && resource_inventory.has_enough_resources(active_item.usage_cost)):
		resource_inventory.remove_resources(active_item.usage_cost)
		start_item_cooldown()
		active_item.use(direction)

func _set_active_item(item: Item) -> void:
	active_item = item

func _on_item_harvest(harvestation_result: Dictionary[GameResource.ResourceType, int]) -> void:
	resource_inventory.add_resources(harvestation_result)
