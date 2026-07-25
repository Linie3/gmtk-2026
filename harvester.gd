extends Node2D

class_name Harvester

signal first_harvest(harvestable: Harvestable)
signal harvest(harvestable: Harvestable)

@export
var harvestable_area: Area2D
var harvesting_enabled: bool = false
var harvested_harvestables: Array[Harvestable] = []

func _ready() -> void:
	harvestable_area.area_entered.connect(_on_area_entered)

func start_harvesting() -> void:
	harvested_harvestables.clear()
	harvesting_enabled = true

func finish_harvesting() -> void:
	harvesting_enabled = false

func _on_area_entered(area: Area2D) -> void:
	var target: Node = area.get_parent()
	if (target is Harvestable && harvesting_enabled):
		harvested_harvestables.append(target)
		target.harvest()
		if (harvested_harvestables.size() == 1):
			first_harvest.emit(target)
		harvest.emit(target)
