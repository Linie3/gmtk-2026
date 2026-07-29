extends Control

@export
var harvestable: Harvestable
@export
var health_bar: Label
@export
var visible_timer: Timer

func _ready() -> void:
	visible = false
	health_bar.text = str(harvestable.current_health) + " / " + str(harvestable.harvesting_health)
	harvestable.harvested.connect(_on_harvested)
	visible_timer.timeout.connect(func(): visible = false)

func _on_harvested(new_health: int) -> void:
	health_bar.text = str(new_health) + " / " + str(harvestable.harvesting_health)
	visible = true
	visible_timer.start()
