extends Node2D

class_name Harvestable

signal harvested()
signal harvestable_depleted()

@export
var harvesting_health: int = 1
@export
var harvestation_results: Dictionary[GameResource.ResourceType, int]

func harvest() -> Dictionary[GameResource.ResourceType, int]:
	if (harvesting_health > 0):
		harvesting_health -= 1
		harvested.emit()
		if (harvesting_health == 0):
			harvestable_depleted.emit()
	return harvestation_results