class_name HUD
extends VBoxContainer

@export var game_stats: GameStats

@onready var money_lives_label: RichTextLabel = %MoneyLivesLabel
@onready var tooltip: Label = %Tooltip
@onready var wave_button: Button = %WaveButton

func _ready() -> void:
	Events.tower_selected.connect(_on_tower_selected)
	game_stats.game_stats_changed.connect(_on_game_stats_changed)
	_on_game_stats_changed()

func _on_game_stats_changed() -> void:
	money_lives_label.text = "[color={yellow}]$ {money}[/color]\n[color={red}]C {lives}[/color]".format({
		"yellow": "feda84",
		"red": "ff9b83",
		"money": game_stats.money,
		"lives": game_stats.lives_left,
	})

func _on_tower_selected(tower_stats: TowerStats) -> void:
	if not tower_stats:
		tooltip.text = ""
		return
	tooltip.text = "{tower_name}\n${tower_cost}".format({
		"tower_name": tower_stats.name,
		"tower_cost": tower_stats.cost,
	})
