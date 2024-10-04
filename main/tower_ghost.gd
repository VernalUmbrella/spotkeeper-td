class_name TowerGhost
extends Node2D

@export var tower_stats: TowerStats: set=_set_tower_stats

@onready var sprite: Sprite2D = $Sprite
@onready var range_indicator: Panel = $RangeIndicator

func _set_tower_stats(value: TowerStats):
	tower_stats = value
	sprite.texture = tower_stats.texture
	var range_size: Vector2 = Main.TILE_SIZE * (1+2*tower_stats.attack_range)
	range_indicator.size = range_size
	range_indicator.set_position(-range_size / 2)
