class_name HealthBar
extends ProgressBar

@export var wielder: Node2D

func _ready():
	wielder.health_changed.connect(_on_health_changed)

func _on_health_changed(new_health):
	visible = (new_health < max_value)
	value = new_health
