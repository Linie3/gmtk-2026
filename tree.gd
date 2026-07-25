extends Node2D

@export
var harvestable: Harvestable

func _ready() -> void:
	harvestable.harvestable_depleted.connect(func(): queue_free())
