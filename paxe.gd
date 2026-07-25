extends Item

@export
var sprite: Sprite2D
@export
var harvester: Harvester
@export
var resource_inventory: ResourceInventory

func _ready() -> void:
	sprite.visible = false
	harvester.harvest.connect(_on_harvest)

func _on_harvest(target: Harvestable, harvestation_result: Dictionary[GameResource.ResourceType, int]) -> void:
	for resource_type in harvestation_result.keys():
		resource_inventory.add_resources(resource_type, harvestation_result[resource_type])

func use(target_direction: Vector2) -> void:
	harvester.start_harvesting()
	rotation = target_direction.angle()
	sprite.visible = true
	var tween: Tween = get_tree().create_tween()
	tween.finished.connect(func(): 
		sprite.visible = false
		harvester.finish_harvesting()
	)
	tween.tween_property(self, "rotation", target_direction.angle() - deg_to_rad(-90), 0.15)
