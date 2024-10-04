class_name Main
extends Node2D

const TILE_SIZE := Vector2(8, 8)
const HALF_TILE_SIZE := TILE_SIZE / 2

const TowerScene = preload("res://game_objects/towers/tower.tscn")
const BOARD_DIMENSIONS := Vector2i(16, 9)
const TOWER_RESOURCES: Array[TowerStats] = [
	null,
	preload("res://game_objects/towers/laser/laser_tower.tres"),
	preload("res://game_objects/towers/pulse/pulse_tower.tres"),
	preload("res://game_objects/towers/railgun/railgun_tower.tres"),
	preload("res://game_objects/towers/gamma/gamma_tower.tres"),
]

@export var game_stats: GameStats

@onready var map: TileMapLayer = $Map
@onready var tile_cursor: Area2D = $Map/TileCursor
@onready var enemy_path: EnemyPath = $EnemyPath
@onready var hud: HUD = $CanvasLayer/HUD

var selected_tower: TowerStats
var hovered_tile: Vector2i

func _ready() -> void:
	Events.enemy_died.connect(_on_enemy_died)
	Events.enemy_leaked.connect(_on_enemy_leaked)
	Events.tower_selected.connect(_on_tower_selected)
	enemy_path.game_stats = game_stats

func _process(_delta: float) -> void:
	update_cursor()

func _input(event: InputEvent) -> void:
	for tower_i in len(TOWER_RESOURCES):
		if event.is_action_pressed("tower%s" % tower_i):
			Events.tower_selected.emit(TOWER_RESOURCES[tower_i])
	if event.is_action_pressed("place_tower") and selected_tower:
		place_tower(selected_tower)

func update_cursor() -> void:
	var mouse_position: Vector2 = get_local_mouse_position()
	hovered_tile = map.local_to_map(mouse_position)
	tile_cursor.visible = false
	if hovered_tile.x not in range(BOARD_DIMENSIONS.x) or hovered_tile.y not in range(BOARD_DIMENSIONS.y):
		return
	if map.get_cell_tile_data(hovered_tile).get_custom_data("buildable"):
		tile_cursor.visible = true
		tile_cursor.position = (mouse_position - HALF_TILE_SIZE).snapped(TILE_SIZE)

func place_tower(tower_stats: TowerStats) -> void:
	if not tile_cursor.visible:
		return
	if tile_cursor.get_overlapping_areas():
		return
	if game_stats.money < tower_stats.cost:
		# TODO: flash money red, play sound
		return
	game_stats.money -= tower_stats.cost
	var new_tower := TowerScene.instantiate()
	new_tower.set_script(tower_stats.tower_script)
	new_tower.tower_stats = tower_stats
	new_tower.position = tile_cursor.position + HALF_TILE_SIZE
	map.add_child(new_tower)

func _on_enemy_died(enemy_stats: EnemyStats):
	game_stats.money += enemy_stats.loot

func _on_enemy_leaked():
	game_stats.lives_left -= 1

func _on_tower_selected(tower_stats: TowerStats):
	selected_tower = tower_stats
