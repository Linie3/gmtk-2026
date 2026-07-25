extends Item

@export
var sprite: Sprite2D
@export
var harvester: Harvester

func _ready() -> void:
	sprite.visible = false

func use(target_direction: Vector2) -> void:
	harvester.start_harvesting()
	print("Paxe used!")
	rotation = target_direction.angle()
	sprite.visible = true
	var tween: Tween = get_tree().create_tween()
	tween.finished.connect(func(): 
		sprite.visible = false
		harvester.finish_harvesting()
	)
	tween.tween_property(self, "rotation", target_direction.angle() - deg_to_rad(-90), 0.15)
