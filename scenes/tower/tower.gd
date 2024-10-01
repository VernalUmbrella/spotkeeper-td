class_name Tower
extends Node2D

@export var attack_distance: float:
	set(value):
		attack_distance = value
		if not range_shape:
			return
		var attack_size: float = Main.TILE_SIZE*(1+2*attack_distance)
		range_shape.shape = RectangleShape2D.new()
		range_shape.shape.set_size(Vector2(attack_size, attack_size))
@export var damage_per_second: float

@onready var sprite: Sprite2D = $Sprite
@onready var range_shape: CollisionShape2D = $Range/CollisionShape2D
