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
	Game.instance.countdown_state_changed.connect(func(_state: Game.CountdownState): _update_popup_state())

func _process(delta: float) -> void:
	if (Input.is_action_just_pressed("interact") && can_activate()):
		Game.instance.change_countdown_state(Game.CountdownState.COUNTDOWN)

func _on_interacter_entered_range(interacter: Interacter) -> void:
	if (interacter.get_parent() is Entity && interacter.get_parent().entity_component is Player):
		player_in_range = true
		_update_popup_state()

func _on_interacter_left_range(interacter: Interacter) -> void:
	if (interacter.get_parent() is Entity && interacter.get_parent().entity_component is Player):
		player_in_range = false
		_update_popup_state()

func _update_popup_state() -> void:
	popup.visible = can_activate()

func can_activate() -> bool:
	return player_in_range and Game.instance.countdown_state == Game.CountdownState.COUNTUP
