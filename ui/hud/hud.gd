class_name HUD
extends Control

@export var game_stats: GameStats:
	set(value):
		if not is_node_ready():
			await ready
		game_stats = value
		if not game_stats.changed.is_connected(_on_game_stats_changed):
			game_stats.changed.connect(_on_game_stats_changed)
		_on_game_stats_changed()

@onready var money_lives_label: RichTextLabel = %MoneyLivesLabel
@onready var tooltip: Label = %Tooltip
@onready var wave_button: Button = %WaveButton
@onready var you_died: Panel = %YouDied
@onready var you_win: Panel = %YouWin

func _ready() -> void:
	Events.tower_selected.connect(_on_tower_selected)
	_on_tower_selected(null)
	Events.wave_ended.connect(_on_wave_ended)
	Events.game_lost.connect(_on_game_lost)
	Events.game_won.connect(_on_game_won)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("start_wave") and not wave_button.disabled:
		_on_wave_button_pressed()

func _on_game_stats_changed() -> void:
	money_lives_label.text = "[color={yellow}]$ {money}[/color]\n[color={red}]C {lives}[/color]".format({
		"yellow": "feda84",
		"red": "ff9b83",
		"money": game_stats.money,
		"lives": game_stats.lives_left,
	})
	wave_button.text = "%s >>" % (game_stats.current_wave + 1)

func _on_tower_selected(tower_stats: TowerStats) -> void:
	if not tower_stats:
		tooltip.text = ""
		return
	tooltip.text = "{tower_name}\n${tower_cost}".format({
		"tower_name": tower_stats.name,
		"tower_cost": tower_stats.cost,
	})

func _on_wave_button_pressed() -> void:
	wave_button.disabled = true
	Events.wave_started.emit()

func _on_wave_ended() -> void:
	wave_button.disabled = false

func _on_game_lost() -> void:
	var tween := create_tween()
	you_died.show()
	tween.tween_property(you_died, "modulate", Color.WHITE, 1.8).from(Color.TRANSPARENT)
	tween.tween_interval(3)
	tween.tween_callback(reset_game)

func _on_game_won() -> void:
	wave_button.disabled = true
	var tween := create_tween()
	you_win.show()
	tween.tween_property(you_win, "modulate", Color.WHITE, 1.8).from(Color.TRANSPARENT)
	tween.tween_interval(3)

func reset_game() -> void:
	get_tree().change_scene_to_file("res://ui/title_screen/title_screen.tscn")
	for main_scene in get_tree().get_nodes_in_group("main"):
		main_scene.queue_free()

func _on_reset_button_pressed() -> void:
	reset_game()
