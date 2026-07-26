extends Node2D

class_name Harvester

signal first_harvest(harvestable: Harvestable, harvestation_result: Dictionary[GameResource.ResourceType, int])
signal harvest(harvestable: Harvestable, harvestation_result: Dictionary[GameResource.ResourceType, int])

@export
var harvestable_area: Area2D
@export
var damage: int = 1
var harvesting_enabled: bool = false
var harvested_harvestables: Array[Harvestable] = []

func _ready() -> void:
	harvestable_area.area_entered.connect(_on_area_entered)

func start_harvesting() -> void:
	harvested_harvestables.clear()
	harvestable_area.monitoring = true
	harvesting_enabled = true

func finish_harvesting() -> void:
	harvestable_area.monitoring = false
	harvesting_enabled = false

func _on_area_entered(area: Area2D) -> void:
	var target: Node = area.get_parent()
	if (target is Harvestable && harvesting_enabled && !(target.get_parent() is Entity && target.get_parent().entity_component is Player)):
		harvested_harvestables.append(target)
		var harvestation_result: Dictionary[GameResource.ResourceType, int] = target.harvest(damage)
		if (harvested_harvestables.size() == 1):
			first_harvest.emit(target, harvestation_result)
		harvest.emit(target, harvestation_result)
