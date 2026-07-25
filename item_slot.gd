extends Control

class_name ItemSlot

@export
var icon: TextureRect
@export
var border: TextureRect
var item: Item
var normal_border = preload("res://assets/item_slot_border_normal.png")
var selected_border = preload("res://assets/item_slot_border_selected.png")

func set_item(new_item: Item):
	item = new_item
	icon.texture = Item.get_item_icon(item.item_name)

func select():
	border.texture = selected_border

func deselect():
	border.texture = normal_border
