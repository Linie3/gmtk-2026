extends CanvasLayer

@export var game: Game
@export var timer: Label
@export var player: Player
@export var resources_container: Control
var resource_container: PackedScene = preload("res://resource_container.tscn")
var resource_containers: Dictionary[GameResource.ResourceType, Control] = {}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	game.timer_updated.connect(_on_timer_updated)
	for resource_type in GameResource.get_resource_types():
		var container: ResourceContainer = resource_container.instantiate()
		resource_containers[resource_type] = container
		container.set_resource(resource_type, 0)
		resources_container.add_child(container) 
	player.resource_inventory.resource_changed.connect(_on_resource_changed)

func _on_resource_changed(resource_type: GameResource.ResourceType, amount: int) -> void:
	resource_containers[resource_type].set_resource(resource_type, amount)

func _on_timer_updated(new_timer: int) -> void:
	var total_seconds: float = new_timer / 1000.0
	var minutes: int = int(total_seconds) / 60
	var seconds: float = fmod(total_seconds, 60.0)
	timer.text = "Time: %02d:%04.1f" % [minutes, seconds]
