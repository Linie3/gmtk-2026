extends Control

class_name ItemSlot

@export
var icon: TextureRect
@export
var border: TextureRect
@export
var costs_container: HBoxContainer
@export
var slot_index_label: Label
var resource_container_scene: PackedScene = preload("res://resource_container.tscn")
var item: Item
var normal_border = preload("res://assets/item_slot_border_normal.png")
var selected_border = preload("res://assets/item_slot_border_selected.png")
var resource_containers: Dictionary[GameResource.ResourceType, ResourceContainer] = {}

func set_data(new_item: Item, resource_inventory: ResourceInventory, slot_index: int):
	item = new_item
	icon.texture = Item.get_item_icon(item.item_name)
	for child in costs_container.get_children():
		costs_container.remove_child(child)
	resource_containers.clear()
	for resource_type in item.usage_cost:
		var resource_container: ResourceContainer = resource_container_scene.instantiate()
		resource_container.set_resource(resource_type, item.usage_cost[resource_type])
		resource_containers[resource_type] = resource_container
		costs_container.add_child(resource_container)
		resource_container.content_size = 32
		resource_container.insufficient_resources = resource_inventory.get_resource_amount(resource_type) < item.usage_cost[resource_type]
	resource_inventory.resource_changed.connect(_on_resources_changed)
	slot_index_label.text = str(slot_index + 1)

func _on_resources_changed(resource_type: GameResource.ResourceType, amount: int) -> void:
	if resource_containers.has(resource_type):
		resource_containers[resource_type].insufficient_resources = amount < item.usage_cost[resource_type]

func select():
	border.texture = selected_border

func deselect():
	border.texture = normal_border
