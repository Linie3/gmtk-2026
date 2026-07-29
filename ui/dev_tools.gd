extends CenterContainer

@export
var ui: UI
var game: Game
var world: World
var player: Player

@export
var pause_game_button: CheckButton
@export
var stage_button: Button
@export
var stage_mode: OptionButton
@export
var stage_step: SpinBox
@export
var trigger_showdown: Button
@export
var set_timer_button: Button
@export
var set_timer_mode: OptionButton
@export
var set_timer_minutes: SpinBox
@export
var set_timer_seconds: SpinBox
@export
var sound_type: OptionButton
@export
var sound_toggle: CheckButton
@export
var sound_volume: HSlider
@export
var sound_volume_text: Label
@export
var invulnerable: CheckButton
@export
var kill: Button
@export
var health: Button
@export
var health_mode: OptionButton
@export
var health_amount: SpinBox
@export
var clear_enemies: Button
@export
var peaceful: CheckButton
@export
var enemy_spawn: Button
@export
var enemy_type: OptionButton
@export
var enemy_amount: SpinBox
@export
var resources_fill: Button
@export
var resources_clear: Button
@export
var resource_mode: OptionButton
@export
var resource_type: OptionButton
@export
var resource_amount: SpinBox
@export
var items_fill: Button
@export
var items_clear: Button
@export
var item_mode: OptionButton
@export
var item_type: OptionButton
@export
var item_slot: SpinBox

func _ready() -> void:
	visible = false
	game = ui.game
	world = game.world
	player = world.player

	pause_game_button.toggled.connect(_on_pause_game_toggled)
	stage_button.pressed.connect(_on_advance_stage_pressed)
	trigger_showdown.pressed.connect(_on_trigger_showdown_pressed)
	set_timer_button.pressed.connect(_on_set_timer_pressed)
	
	sound_toggle.toggled.connect(_on_sound_toggled)
	sound_volume.value_changed.connect(_on_sound_volume_changed)
	
	invulnerable.toggled.connect(_on_invulnerable_toggled)
	kill.pressed.connect(_on_kill_pressed)
	health.pressed.connect(_on_health_pressed)
	
	clear_enemies.pressed.connect(_on_clear_enemies_pressed)
	peaceful.toggled.connect(_on_peaceful_toggled)
	enemy_spawn.pressed.connect(_on_enemy_spawn_pressed)
	
	resources_fill.pressed.connect(_on_resources_fill_pressed)
	resources_clear.pressed.connect(_on_resources_clear_pressed)
	resource_mode.item_selected.connect(_on_resource_mode_selected)
	
	items_fill.pressed.connect(_on_items_fill_pressed)
	items_clear.pressed.connect(_on_items_clear_pressed)
	item_mode.item_selected.connect(_on_item_mode_selected)
	item_type.item_selected.connect(_on_item_type_selected)
	item_slot.value_changed.connect(_on_item_slot_changed)

	for resource_type_ in GameResource.get_resource_types():
		resource_type.add_item(GameResource.get_resource_name(resource_type_).to_pascal_case(), resource_type_)
		
	for item_type_ in GameItem.get_item_types():
		item_type.add_item(item_type_.to_pascal_case())

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("dev_tools"):
		visible = !visible

func _on_pause_game_toggled(toggled_on: bool) -> void:
	get_tree().paused = toggled_on

func _on_advance_stage_pressed() -> void:
	game.advance_stage(int(stage_step.value))

func _on_trigger_showdown_pressed() -> void:
	game.trigger_showdown()

func _on_set_timer_pressed() -> void:
	var amount: int = int(set_timer_minutes.value) * 60000 + int(set_timer_seconds.value) * 1000
	match set_timer_mode.selected:
		0:
			game.timer = amount
		1:
			game.timer += amount
		2:
			game.timer -= amount

func _on_sound_toggled(_toggled_on: bool) -> void:
	AudioServer.set_bus_mute(0, !_toggled_on)

func _on_sound_volume_changed(_value: float) -> void:
	AudioServer.set_bus_volume_db(0, _value)
	sound_volume_text.text = "%.2f" % [_value]

func _on_invulnerable_toggled(_toggled_on: bool) -> void:
	player.harvestable.invulnerable = _toggled_on

func _on_kill_pressed() -> void:
	player.harvestable.current_health = 0

func _on_health_pressed() -> void:
	match health_mode.selected:
		0:
			player.harvestable.current_health = int(health_amount.value)
		1:
			player.harvestable.current_health += int(health_amount.value)
		2:
			player.harvestable.current_health -= int(health_amount.value)
		
func _on_clear_enemies_pressed() -> void:
	world.clear_entities(World.EntityType.ENEMY)

func _on_peaceful_toggled(_toggled_on: bool) -> void:
	world.peaceful = _toggled_on
	world.clear_entities(World.EntityType.ENEMY)

func _on_enemy_spawn_pressed() -> void:
	pass

func _on_resources_fill_pressed() -> void:
	for resource_type in GameResource.get_resource_types():
		player.resource_inventory.add_resource(resource_type, 100000)

func _on_resources_clear_pressed() -> void:
	player.resource_inventory.clear_resources()

func _on_resource_mode_selected(_index: int) -> void:
	var callback: Callable
	match _index:
		0:
			callback = player.resource_inventory.add_resource
		1:
			callback = player.resource_inventory.remove_resource
		2:
			callback = player.resource_inventory.set_resource
	callback.call(resource_type.selected, int(resource_amount.value))

func _on_items_fill_pressed() -> void:
	for item_type_ in GameItem.get_item_types():
		player.items.add_item(GameItem.create_item(item_type_))

func _on_items_clear_pressed() -> void:
	player.items.clear_items()

func _on_item_mode_selected(_index: int) -> void:
	var item_name: StringName = item_type.get_item_text(item_type.selected).to_snake_case()
	var item_index: float = item_slot.value
	match _index:
		0:
			player.items.add_item(GameItem.create_item(item_name))
		

func _on_item_type_selected(_index: int) -> void:
	pass

func _on_item_slot_changed(_value: float) -> void:
	pass
