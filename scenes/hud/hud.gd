class_name HUD
extends VBoxContainer

@export var game_stats: GameStats

@onready var money_lives_label: RichTextLabel = %MoneyLivesLabel
@onready var tooltip: Label = %Tooltip
@onready var wave_button: Button = %WaveButton

func _ready() -> void:
	Events.tower_selected.connect(_on_tower_selected)
	_on_tower_selected(null)
	Events.wave_ended.connect(_on_wave_ended)
	game_stats.changed.connect(_on_game_stats_changed)
	_on_game_stats_changed()
	Events.game_lost.connect(_on_game_lost)

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
	tooltip.text = "YOU DIED"
