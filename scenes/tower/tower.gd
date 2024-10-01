class_name Tower
extends Node2D

@export var attack_range: float:
	set(value):
		attack_range = value
		if not range_shape:
			return
		range_shape.shape = RectangleShape2D.new()
		range_shape.shape.set_size(Main.TILE_SIZE * (1+2*attack_range))
@export var damage_per_second: float

@onready var sprite: Sprite2D = $Sprite
@onready var range_area: Area2D = $AttackRange
@onready var range_shape: CollisionShape2D = $AttackRange/CollisionShape2D
@onready var laser: Line2D = $Laser

var current_target: Enemy

func _ready() -> void:
	laser.add_point(Main.HALF_TILE_SIZE)
	laser.add_point(Vector2.ZERO)

func _process(delta: float) -> void:
	locate_target()
	attack(delta)

func locate_target() -> void:
	var candidates: Array[Enemy]
	for overlapper: Area2D in range_area.get_overlapping_areas():
		var enemy: Enemy = overlapper.get_parent() #TODO: rework to avoid get_parent?
		if enemy.is_in_group("enemies"):
			candidates.append(enemy)
	if not candidates:
		current_target = null
		return
	current_target = candidates[0] #TODO: get based on path progress

func attack(delta: float) -> void:
	if not current_target:
		laser.visible = false
		return
	laser.visible = true
	laser.points[1] = current_target.global_position - global_position
	current_target.current_health -= (delta * damage_per_second)
