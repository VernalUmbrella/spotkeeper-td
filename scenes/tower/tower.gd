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
@onready var range: Area2D = $Range
@onready var range_shape: CollisionShape2D = $Range/CollisionShape2D
@onready var laser: Line2D = $Laser

var current_target: Enemy

func _ready() -> void:
	laser.add_point(Vector2.ZERO)
	laser.add_point(Vector2.ZERO)

func _process(delta: float) -> void:
	locate_target()
	attack(delta)

func locate_target() -> void:
	var candidates: Array[Enemy]
	for overlapper: Area2D in range.get_overlapping_areas():
		var enemy: Enemy = overlapper.get_parent() #TODO: rework to avoid get_parent?
		if enemy.is_in_group("enemies"):
			candidates.append(enemy)
	if not candidates:
		return
	current_target = candidates[0] #TODO: get based on path progress

func attack(delta: float) -> void:
	if not current_target:
		laser.visible = false
		return
	laser.visible = true
	laser.points[1] = current_target.global_position - global_position
	current_target.current_health -= (delta * damage_per_second)
