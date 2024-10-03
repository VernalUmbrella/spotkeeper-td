class_name Enemy
extends PathFollow2D

@export var enemy_stats: EnemyStats

@onready var sprite: Sprite2D = $Sprite
@onready var hitbox: Area2D = $Hitbox
@onready var health_bar: ProgressBar = $HealthBar

var max_health: float
var current_health: float:
	set(value):
		current_health = value
		health_bar.value = current_health
		health_bar.visible = (current_health < enemy_stats.max_health)

func _ready() -> void:
	sprite.texture = enemy_stats.texture
	max_health = enemy_stats.max_health
	health_bar.max_value = max_health
	current_health = max_health

func _process(delta: float) -> void:
	if current_health <= 0:
		die()
	step_forward(delta)

func step_forward(delta: float) -> void:
	progress += enemy_stats.speed * delta
	if progress_ratio >= 1.0:
		leak()

func die() -> void:
	Events.enemy_died.emit(enemy_stats)
	queue_free()

func leak() -> void:
	Events.enemy_leaked.emit()
	queue_free()
