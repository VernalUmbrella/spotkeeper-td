class_name EnemyStats
extends Resource

@export_group("Visuals")
@export var texture: Texture2D
@export_group("Attributes")
@export var max_health: float
@export var speed: float
@export var loot: int

func clone() -> EnemyStats:
	var output := EnemyStats.new()
	output.texture = texture
	output.max_health = max_health
	output.speed = speed
	output.loot = loot
	return output
