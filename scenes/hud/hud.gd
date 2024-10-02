class_name HUD
extends VBoxContainer

@export var game_stats: GameStats

@onready var money_lives_label: RichTextLabel = %MoneyLivesLabel
@onready var tooltip: Label = %Tooltip
@onready var wave_button: Button = %WaveButton

func _ready() -> void:
	game_stats.game_stats_changed.connect(_on_game_stats_changed)
	_on_game_stats_changed()

func _on_game_stats_changed() -> void:
	money_lives_label.text = "[color={yellow}]$ {money}[/color]\n[color={red}]() {lives}[/color]".format({
		"yellow": "feda84",
		"red": "ff9b83",
		"money": game_stats.money,
		"lives": game_stats.lives_left,
	})
