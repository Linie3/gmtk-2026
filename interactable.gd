extends Node2D

class_name Interactable

signal hovered()
signal unhovered()
signal interacter_entered_range(interacter: Interacter)
signal interacter_left_range(interacter: Interacter)

static var counter: int = 0:
	set(value):
		counter = value
		if value > 0:
			Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)
		else:
			Input.set_default_cursor_shape(Input.CURSOR_ARROW)
			
@export
var collision_node: Area2D

func _ready() -> void:
	collision_node.area_entered.connect(_on_area_entered)
	collision_node.area_exited.connect(_on_area_exited)
	collision_node.mouse_entered.connect(_on_mouse_entered)
	collision_node.mouse_exited.connect(_on_mouse_exited)

func _on_area_entered(area: Area2D) -> void:
	if (area is Interacter):
		interacter_entered_range.emit(area)

func _on_area_exited(area: Area2D) -> void:
	if (area is Interacter):
		interacter_left_range.emit(area)

func _on_mouse_entered() -> void:
	hovered.emit()
	counter += 1

func _on_mouse_exited() -> void:
	unhovered.emit()
	counter -= 1
	
