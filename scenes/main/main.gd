class_name Main
extends Node2D

const TILE_SIZE := Vector2(8, 8)
const HALF_TILE_SIZE := TILE_SIZE / 2
const LASER_TOWER = preload("res://scenes/tower/laser_tower.tscn")

@onready var map: TileMapLayer = $Map
@onready var tile_cursor: TileCursor = $Map/TileCursor

func _process(_delta: float) -> void:
	update_cursor()

func update_cursor() -> void:
	var mouse_position: Vector2 = get_local_mouse_position()
	var hovered_tile_data: TileData = map.get_cell_tile_data(map.local_to_map(mouse_position)) # TODO: test with real tiles
	tile_cursor.position = (mouse_position - HALF_TILE_SIZE).snapped(TILE_SIZE)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		place_tower(LASER_TOWER)

func place_tower(tower_scene: PackedScene) -> void:
	var new_tower := tower_scene.instantiate()
	map.add_child(new_tower)
	new_tower.position = tile_cursor.position
