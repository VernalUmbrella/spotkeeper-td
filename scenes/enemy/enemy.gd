class_name Enemy
extends PathFollow2D

signal health_changed(new_health: float)

@export var enemy_stats: EnemyStats
# TODO: sprite is set to 1/16 scale, change it back to 1 when we get the properly sized sprite

@onready var sprite: Sprite2D = $Sprite
@onready var hitbox: Area2D = $Hitbox
@onready var health_bar: ProgressBar = $HealthBar

var max_health: float
var current_health: float:
	set(value):
		current_health = value
		health_changed.emit(value)
		if current_health <= 0:
			die()

func _ready() -> void:
	sprite.texture = enemy_stats.texture
	max_health = enemy_stats.max_health
	health_bar.max_value = max_health
	current_health = max_health

func _process(delta: float) -> void:
	step_forward(delta)

func step_forward(delta: float) -> void:
	progress += enemy_stats.speed * delta
	progress_ratio = fmod(progress_ratio, 1.0) # TODO remove
	

func die() -> void:
	queue_free()
