extends Node2D

class_name World

static var instance: World
static func add_object(object: Node2D) -> void:
	instance._add_object(object)

signal player_position_changed(new_position: Vector2)

const tree: PackedScene = preload("res://tree.tscn")
const rock: PackedScene = preload("res://rock.tscn")
@export 	
var navigation_region: NavigationRegion2D
@export
var objects_container: Node2D
@export
var player_component: Entity
@export
var camera: Camera2D
@export
var blackout_rect: ColorRect
@export
var game: Game
@export
var blackout_max_radius: float
@export
var blackout_min_radius: float
@export
var enemy_timer: Timer
var player: Player
var last_player_position: Vector2 = Vector2.ZERO
var navigation_update_scheduled: bool = false
var blackout_radius: float:
	set(value):
		blackout_rect.material.set_shader_parameter("radius", value)
		blackout_radius = value
var radius_tween: Tween
var enemies: Array[PackedScene] = [
	preload("res://slime.tscn"),
	preload("res://ghost.tscn"),
]

func _init() -> void:
	instance = self

func _ready() -> void:
	blackout_radius = blackout_max_radius
	game.countdown_state_changed.connect(_on_countdown_state_changed)
	player = player_component.entity_component
	for position in get_random_positions(15, Rect2(Vector2(-1000, -1000), Vector2(2000, 2000))):
		var new_tree : Node2D = tree.instantiate()
		new_tree.position = position
		_add_object(new_tree)
	for position in get_random_positions(9, Rect2(Vector2(-1000, -1000), Vector2(2000, 2000))):
		var new_rock : Node2D = rock.instantiate()
		new_rock.position = position
		_add_object(new_rock)
	enemy_timer.timeout.connect(spawn_enemy)

func _process(delta: float) -> void:
	blackout_rect.material.set_shader_parameter("blackout_position", Vector2(0, 0))
	var inv_transform: Transform2D = get_viewport().get_canvas_transform().affine_inverse()
	blackout_rect.material.set_shader_parameter("global_transform_inv", Transform3D(inv_transform))
	if navigation_update_scheduled:
		navigation_region.bake_navigation_polygon()
		navigation_update_scheduled = false
	if player_component:
		if last_player_position.distance_to(player_component.position) > 50:
			player_position_changed.emit(player_component.position)
			last_player_position = player_component.position

func get_random_positions(amount: int, area: Rect2) -> Array[Vector2]:
	var positions: Array[Vector2] = []
	var rng := RandomNumberGenerator.new()
	rng.randomize()

	for i in amount:
		var pos := Vector2(
			rng.randf_range(area.position.x, area.end.x),
			rng.randf_range(area.position.y, area.end.y)
		)
		positions.append(pos)

	return positions

func _add_object(object: Node2D) -> void:
	objects_container.add_child(object)

func schedule_navigation_update() -> void:
	navigation_update_scheduled = true

func _on_countdown_state_changed(new_state: Game.CountdownState) -> void:
	if radius_tween and radius_tween.is_running():
		radius_tween.kill()
	match new_state:
		Game.CountdownState.COUNTDOWN:
			blackout_rect.material.set_shader_parameter("blackout_enabled", true)
			radius_tween = get_tree().create_tween()
			radius_tween.tween_property(self, "blackout_radius", blackout_min_radius, 3.0)
			radius_tween.finished.connect(_on_radius_tween_finished)
			enemy_timer.wait_time = 2
			enemy_timer.start()
		Game.CountdownState.COUNTUP:
			radius_tween = get_tree().create_tween()
			radius_tween.tween_property(self, "blackout_radius", blackout_max_radius, 3.0)
			enemy_timer.wait_time = 14
			enemy_timer.start()

func _on_radius_tween_finished() -> void:
	if game.countdown_state == Game.CountdownState.COUNTUP:
		blackout_rect.material.set_shader_parameter("blackout_enabled", false)

func spawn_enemy() -> void:
	randomize()
	var enemy: Node = enemies[randi_range(0, enemies.size() - 1)].instantiate()
	var random_angle: float = randf_range(0.0, TAU)
	var spawn_offset: Vector2 = Vector2.RIGHT.rotated(random_angle) * 1500
	enemy.position = last_player_position + spawn_offset
	add_object(enemy)
