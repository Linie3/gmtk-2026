extends Item

@export
var sprite: Sprite2D

func use(target_direction: Vector2) -> void:
	print("Paxe used!")
	rotation = target_direction.angle()
	sprite.visible = true
	var tween: Tween = get_tree().create_tween()
	tween.finished.connect(func(): sprite.visible = false)
	tween.tween_property(self, "rotation", target_direction.angle() - deg_to_rad(-90), 0.15)
