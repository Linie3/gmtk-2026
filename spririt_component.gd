extends EntityComponent

@export var hitbox: Area2D
@export var entity: Node2D
@export var animation_sprite: Sprite2D

@export var acceleration: float = 300.0  # Pull force toward player
@export var max_speed: float = 500.0     # Speed cap
@export var drag: float = 0.5            # Slows down overshoot (higher = stops faster)

var velocity: Vector2 = Vector2.ZERO
var target_player_position: Vector2 = Vector2.ZERO

func _ready() -> void:
	World.instance.player_position_changed.connect(_on_player_position_changed)
	_on_player_position_changed(Vector2.ZERO)
	hitbox.body_entered.connect(_on_body_entered)

func _process(delta: float) -> void:
	# 1. Direction toward target
	var pull_direction: Vector2 = (target_player_position - entity.global_position).normalized()
	
	# 2. Add acceleration toward player
	velocity += pull_direction * acceleration * delta
	
	# 3. Apply drag so it doesn't overshoot endlessly
	velocity = velocity.move_toward(Vector2.ZERO, drag * velocity.length() * delta)
	
	# 4. Cap max speed
	velocity = velocity.limit_length(max_speed)
	
	# 5. Move entity
	entity.global_position += velocity * delta
	
	# 6. Flip sprite based on horizontal movement
	if animation_sprite and velocity.x != 0:
		animation_sprite.flip_h = velocity.x < 0

func _on_player_position_changed(player_position: Vector2) -> void:
	target_player_position = player_position

func _on_body_entered(body: Node2D) -> void:
	if body is Entity and body.entity_component is Player:
		for child in body.get_children():
			if child is Harvestable:
				child.harvest(1)