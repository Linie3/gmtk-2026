extends Node2D

class_name Harvestable

signal harvested(new_health: int)
signal harvestable_depleted()

@export
var harvesting_health: int = 1
var current_health: int = 1:
	set(value):
		current_health = max(0, value)
		harvested.emit(value)
		if value <= 0:
			harvestable_depleted.emit()
			get_parent().queue_free()
var invulnerable: bool = false

@export
var harvestation_results: Dictionary[GameResource.ResourceType, int]

func _ready() -> void:
	harvesting_health = round(float(harvesting_health) * Game.instance.difficulty_factor)
	current_health = harvesting_health

func harvest(damage: int) -> Dictionary[GameResource.ResourceType, int]:
	if invulnerable:
		return {}
	if current_health <= 0:
		return {}
	var actual_damage = min(damage, current_health)
	var previous_damage_dealt: int = harvesting_health - current_health
	current_health -= actual_damage
	var total_damage_dealt: int = harvesting_health - current_health
	var result: Dictionary[GameResource.ResourceType, int] = {}
	for resource_type in harvestation_results:
		var total_amount: int = harvestation_results[resource_type]
		var owed_before: int = (total_amount * previous_damage_dealt) / harvesting_health
		var owed_now: int = (total_amount * total_damage_dealt) / harvesting_health

		var amount_this_hit: int = owed_now - owed_before
		if amount_this_hit > 0:
			result[resource_type] = amount_this_hit
	return result
