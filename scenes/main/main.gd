class_name Main
extends Node2D

const TILE_SIZE := Vector2(8, 8)
const HALF_TILE_SIZE := TILE_SIZE / 2
const TowerScene = preload("res://scenes/tower/tower.tscn")
const LASER_TOWER = preload("res://resources/towers/laser_tower.tres")

@export var game_stats: GameStats

@onready var map: TileMapLayer = $Map
@onready var tile_cursor: TileCursor = $Map/TileCursor

func _ready() -> void:
	Events.enemy_died.connect(_on_enemy_died)

func _process(_delta: float) -> void:
	update_cursor()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		place_tower(LASER_TOWER)

func update_cursor() -> void:
	var mouse_position: Vector2 = get_local_mouse_position()
	var hovered_tile_data: TileData = map.get_cell_tile_data(map.local_to_map(mouse_position)) # TODO: test with real tiles
	tile_cursor.position = (mouse_position - HALF_TILE_SIZE).snapped(TILE_SIZE)

func place_tower(tower_stats: TowerStats) -> void:
	var new_tower := TowerScene.instantiate()
	new_tower.set_script(tower_stats.tower_script)
	new_tower.tower_stats = tower_stats
	new_tower.position = tile_cursor.position
	map.add_child(new_tower)

func _on_enemy_died(enemy_stats: EnemyStats):
	game_stats.money += enemy_stats.loot
