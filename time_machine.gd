extends Node2D

class_name TimeMachine

@export
var popup: Control
@export
var interactable: Interactable
var player_in_range: bool = false

func _ready() -> void:
	popup.visible = false
	interactable.interacter_entered_range.connect(_on_interacter_entered_range)
	interactable.interacter_left_range.connect(_on_interacter_left_range)

func _process(delta: float) -> void:
	if (Input.is_action_just_pressed("interact") && player_in_range):
		Game.start_wave()

func _on_interacter_entered_range(interacter: Interacter) -> void:
	if (interacter.get_parent() is Entity && interacter.get_parent().entity_component is Player):
		player_in_range = true
		popup.visible = true

func _on_interacter_left_range(interacter: Interacter) -> void:
	if (interacter.get_parent() is Entity && interacter.get_parent().entity_component is Player):
		player_in_range = false
		popup.visible = false
