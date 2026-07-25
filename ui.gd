extends CanvasLayer

@export var game: Game
@export var timer: Label
@export var player: Player
@export var resources_container: Control
@export
var item_slots_container: Control
var resource_container: PackedScene = preload("res://resource_container.tscn")
var resource_containers: Dictionary[GameResource.ResourceType, Control] = {}
var item_slot: PackedScene = preload("res://item_slot.tscn")
var item_slots: Array[ItemSlot] = []
var items: Array[Item]
var active_item: Item

func _ready() -> void:
	game.timer_updated.connect(_on_timer_updated)
	for resource_type in GameResource.get_resource_types():
		var container: ResourceContainer = resource_container.instantiate()
		resource_containers[resource_type] = container
		container.set_resource(resource_type, 0)
		resources_container.add_child(container) 
	player.resource_inventory.resource_changed.connect(_on_resource_changed)
	player.items.items_changed.connect(_on_items_changed)
	player.items.active_item_changed.connect(_on_active_item_changed)

func _on_resource_changed(resource_type: GameResource.ResourceType, amount: int) -> void:
	resource_containers[resource_type].set_resource(resource_type, amount)

func _on_items_changed(new_items: Array[Item]) -> void:
	for child in item_slots_container.get_children():
		item_slots_container.remove_child(child)
	item_slots.clear()
	for item in new_items:
		var new_item_slot: ItemSlot = item_slot.instantiate()
		new_item_slot.set_item(item)
		item_slots.append(new_item_slot)
		item_slots_container.add_child(new_item_slot)
	var active_item_index: int = new_items.find(active_item)
	if active_item_index >= 0:
		item_slots[active_item_index].select()	
	items = new_items

func _on_active_item_changed(item: Item) -> void:
	var old_active_item_index: int = items.find(active_item)
	if old_active_item_index >= 0:
		item_slots[old_active_item_index].deselect()	
	active_item = item
	var new_active_item_index: int = items.find(active_item)
	if new_active_item_index >= 0:
		item_slots[new_active_item_index].select()	

func _on_timer_updated(new_timer: int) -> void:
	var total_seconds: float = new_timer / 1000.0
	var minutes: int = int(total_seconds) / 60
	var seconds: float = fmod(total_seconds, 60.0)
	timer.text = "Time: %02d:%04.1f" % [minutes, seconds]
