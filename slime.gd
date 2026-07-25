extends CharacterBody2D

@export
var navigation_agent: NavigationAgent2D
@export
var speed: float = 100.0
@export
var animation_sprite: AnimatedSprite2D

func _ready() -> void:
	World.instance.player_position_changed.connect(_on_player_position_changed)

func _physics_process(delta: float) -> void:
	if navigation_agent.is_navigation_finished() or position.distance_to(navigation_agent.target_position) < 200:
		print("Reached destination")
	else:
		var next_position: Vector2 = navigation_agent.get_next_path_position()
		velocity = (next_position - position).normalized() * speed
		if velocity.x > 0:
			animation_sprite.flip_h = true
		else:
			animation_sprite.flip_h = false
		move_and_slide()
		
func _on_player_position_changed(player_position: Vector2) -> void:
	navigation_agent.target_position = player_position
