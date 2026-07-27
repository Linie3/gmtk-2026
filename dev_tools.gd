extends CenterContainer

@export
var ui: UI
var game: Game

@export
var pause_game_button: Button
@export
var advance_stage_button: Button
@export
var advance_stage_button_step: TextEdit
@export
var trigger_showdown: Button
@export
var set_timer_button: Button
@export
var set_timer_minutes: TextEdit
@export
var set_timer_seconds: TextEdit

func _ready() -> void:
	return
	visible = false
	game = ui.game
	pause_game_button.pressed.connect(func() -> void: get_tree().paused = !get_tree().paused)
	advance_stage_button.pressed.connect(func() -> void: game.advance_stage(advance_stage_button_step.text.to_int()))
	trigger_showdown.pressed.connect(game.trigger_showdown)
	set_timer_button.pressed.connect(func() -> void: game.timer = set_timer_minutes.text.to_int() * 60000 + set_timer_seconds.text.to_int() * 1000)

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("dev_tools"):
		visible = !visible
