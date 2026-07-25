extends HBoxContainer

class_name ResourceContainer

@export
var amount_label: Label
@export
var resource_icon: TextureRect

func set_resource(resource: GameResource.ResourceType, amount: int):
	resource_icon.texture = GameResource.get_resource_icon(resource)
	amount_label.text = str(amount)
