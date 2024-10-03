class_name EnemyPath
extends Path2D

const EnemyScene = preload("res://scenes/enemy/enemy.tscn")

@export var game_stats: GameStats
@onready var spawn_timer: Timer = $SpawnTimer

var current_wave: Wave:
	get:
		if game_stats.current_wave >= len(game_stats.wave_sequence):
			return null
		return game_stats.wave_sequence[game_stats.current_wave]
var remaining_spawns: int = 0
var active: bool = false

func _ready() -> void:
	Events.wave_started.connect(_on_wave_started)

func _process(_delta: float) -> void:
	if not active:
		return
	if not get_tree().get_nodes_in_group("enemies") and remaining_spawns == 0:
		end_wave()

func _on_wave_started() -> void:
	if not current_wave:
		return
	active = true
	remaining_spawns = current_wave.count
	spawn_timer.wait_time = current_wave.spawn_interval
	spawn_timer.start()

func end_wave() -> void:
	active = false
	game_stats.current_wave += 1
	Events.wave_ended.emit()

func _on_spawn_timer_timeout() -> void:
	var new_spawn = EnemyScene.instantiate()
	new_spawn.enemy_stats = current_wave.enemy_stats
	add_child(new_spawn)
	remaining_spawns -= 1
	if remaining_spawns <= 0:
		spawn_timer.stop()
