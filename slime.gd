extends EntityComponent

@export
var hitbox: Area2D
@export
var entity: CharacterBody2D
@export
var navigation_agent: NavigationAgent2D
@export
var speed: float = 100.0
@export
var animation_sprite: AnimatedSprite2D
@export
var channel_timer: Timer
@export
var jump_timer: Timer
var attack_direction: Vector2 = Vector2.ZERO
var attacking: bool = false
var channeling: bool = false

func _ready() -> void:
	World.instance.player_position_changed.connect(_on_player_position_changed)
	_on_player_position_changed(Vector2.ZERO)
	channel_timer.timeout.connect(_on_attack)
	jump_timer.timeout.connect(_on_attack_finished)
	hitbox.body_entered.connect(_on_body_entered)

func _physics_process(delta: float) -> void:
	if channeling:
		return
	if attacking:
		entity.velocity = attack_direction * speed * 5
		entity.move_and_slide()
	elif navigation_agent.is_navigation_finished() or entity.position.distance_to(navigation_agent.target_position) < 350:
		channeling = true
		animation_sprite.play(&"channel")
		attack_direction = (navigation_agent.target_position - entity.position).normalized()
		channel_timer.start()
	else:
		var next_position: Vector2 = navigation_agent.get_next_path_position()
		entity.velocity = (next_position - entity.position).normalized() * speed
		if entity.velocity.x > 0:
			animation_sprite.flip_h = true
		else:
			animation_sprite.flip_h = false
		entity.move_and_slide()

func _on_attack() -> void:
	channeling = false
	attacking = true
	animation_sprite.play(&"attack")
	jump_timer.start()

func _on_attack_finished() -> void:
	attacking = false
	animation_sprite.play(&"default")

func _on_player_position_changed(player_position: Vector2) -> void:
	navigation_agent.target_position = player_position

func _on_body_entered(body: Node2D) -> void:
	if body is Entity and body.entity_component is Player:
		for child in body.get_children():
			if child is Harvestable:
				child.harvest(1)
