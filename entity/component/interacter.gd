extends Area2D

class_name Interacter

signal interactable_entered_range(interactable: Interactable)
signal interactable_left_range(interactable: Interactable)

func _ready() -> void:
	area_entered.connect(_on_area_entered)
	area_exited.connect(_on_area_exited)
	
func _on_area_entered(area: Area2D) -> void:
	var interactable: Interactable = area.get_parent()
	if (interactable is Interactable):
		interactable_entered_range.emit(interactable)

func _on_area_exited(area: Area2D) -> void:
	var interactable: Interactable = area.get_parent()
	if (interactable is Interactable):
		interactable_left_range.emit(interactable)
