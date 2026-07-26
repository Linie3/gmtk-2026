extends HBoxContainer

class_name ResourceContainer

@export
var amount_label: Label
@export
var resource_icon: TextureRect
var content_size: int:
	set(value):
		content_size = value
		resource_icon.custom_minimum_size = Vector2(value, value)
		amount_label.add_theme_font_size_override(&"font_size", ceil(float(value) / 1.8))
var insufficient_resources: bool = false:
	set(value):
		insufficient_resources = value
		if value:
			amount_label.add_theme_color_override(&"font_color", Color(1, 0, 0, 1))
		else:
			amount_label.remove_theme_color_override(&"font_color")

func set_resource(resource: GameResource.ResourceType, amount: int):
	resource_icon.texture = GameResource.get_resource_icon(resource)
	amount_label.text = str(amount)
