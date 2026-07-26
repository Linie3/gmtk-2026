extends Node2D

class_name ItemBox

@export
var sprite: Sprite2D
@export
var resources_container: Control	
@export
var interactable: Interactable
@export
var cost_container: Control
var resource_container_scene: PackedScene = preload("res://resource_container.tscn")
var player_resource_inventory: ResourceInventory
var resource_containers: Dictionary[GameResource.ResourceType, ResourceContainer] = {}
var item: Item

func _ready() -> void:
	interactable.hovered.connect(_on_hovered)
	interactable.unhovered.connect(_on_unhovered)
	interactable.interacted.connect(_on_interacted)
	cost_container.visible = false

func _on_interacted() -> void:
	if player_resource_inventory.has_resources(item.repair_cost):
		player_resource_inventory.remove_resources(item.repair_cost)
		for child in player_resource_inventory.get_parent().get_children():
			if child is ItemInventory:
				child.add_item(item)
				queue_free()

func set_item(new_item: Item) -> void:
	item = new_item
	for resource_type in item.repair_cost:
		item.repair_cost[resource_type] = round(item.repair_cost[resource_type] * Game.instance.difficulty_factor)
	sprite.texture = Item.get_item_icon(item.item_name)
	for resource_type in item.repair_cost:
		var container: ResourceContainer = resource_container_scene.instantiate()
		container.set_resource(resource_type, item.repair_cost[resource_type])
		container.content_size = 32
		container.insufficient_resources = player_resource_inventory.get_resource_amount(resource_type) < item.repair_cost[resource_type]
		resource_containers[resource_type] = container
		resources_container.add_child(container) 
	player_resource_inventory.resource_changed.connect(on_resource_changed)
	
func on_resource_changed(resource_type: GameResource.ResourceType, amount: int) -> void:
	if resource_containers.has(resource_type):
		resource_containers[resource_type].insufficient_resources = amount < item.repair_cost[resource_type]
	
func _on_hovered() -> void:
	cost_container.visible = true	
	
func _on_unhovered() -> void:
	cost_container.visible = false
