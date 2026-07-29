extends Node2D

class_name ItemInventory

signal items_changed(new_items: Array[Item])
signal active_item_changed(new_active_item: Item)

@export
var item_switch_cooldown: Timer
@export
var items_container: Node2D
@export
var resource_inventory: ResourceInventory
var active_item: Item
var active_item_cooldown_finished: bool = true
var items: Array[Item] = []
var cooldowns: Dictionary[StringName, SceneTreeTimer] = {}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for child in items_container.get_children():
		if (child is Item):
			_add_item(child)

func _process(_delta: float) -> void:
	var active_item_movement = round((1 if Input.is_action_just_released(&"next_item") else 0) - (1 if Input.is_action_just_released(&"previous_item") else 0))
	if (active_item_movement != 0):
		var current_item_index: int = items.find(active_item)
		var new_item_index: int = clamp(current_item_index + active_item_movement, 0, items.size() - 1)
		_set_active_item(items[new_item_index])
	for i in range(9):
		if (
			!Input.is_action_just_pressed("item_slot_" + str(i + 1)) or
			items.size() <= i
		):
			continue
		_set_active_item(items[i])		

func add_item(item: Item) -> void:
	add_child(item)
	_add_item(item)

func _add_item(item: Item) -> void:
	item.entity = get_parent()
	items.append(item)
	items_changed.emit(items)
	if (!active_item):
		_set_active_item(item)
	item.harvest.connect(_on_item_harvest)

func remove_item(item: Item) -> void:
	item.harvest.disconnect(_on_item_harvest)
	if (active_item == item):
		# Todo Handle next active item
		_set_active_item(null)
	items.erase(item)
	items_changed.emit(items)

func clear_items() -> void:
	for item in items.duplicate():
		remove_item(item)

func get_items() -> Array[Item]:
	return items

func use_active_item(direction: Vector2) -> void:
	if (
		!active_item ||
		(cooldowns.has(active_item.name) and cooldowns[active_item.name].get_time_left() > 0) ||
		item_switch_cooldown.time_left > 0 ||
		!resource_inventory.has_resources(active_item.usage_cost)
	):
		return
	resource_inventory.remove_resources(active_item.usage_cost)
	cooldowns[active_item.name] = get_tree().create_timer(active_item.cooldown)
	active_item.use(direction)

func _set_active_item(item: Item) -> void:
	if active_item != item:
		item_switch_cooldown.start()	
	active_item = item
	active_item_changed.emit(active_item)

func _on_item_harvest(harvestation_result: Dictionary[GameResource.ResourceType, int]) -> void:
	resource_inventory.add_resources(harvestation_result)
