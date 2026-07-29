extends Item

@export
var sprite: Sprite2D
@export
var harvester: Harvester

func _ready() -> void:
	sprite.visible = false
	harvester.harvest.connect(_on_harvest)

func _on_harvest(target: Harvestable, harvestation_result: Dictionary[GameResource.ResourceType, int]) -> void:
	harvest.emit(harvestation_result)

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
