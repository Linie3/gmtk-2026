extends Node2D

class_name ItemInventory

@export
var item_cooldown: Timer
@export
var items_container: Node2D
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

func _set_active_item(item: Item) -> void:
	active_item = item
