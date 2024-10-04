class_name LaserTower
extends Tower

var laser: Line2D

func _ready() -> void:
	super._ready()
	laser = Line2D.new()
	laser.width = 1
	laser.default_color = tower_stats.attack_color
	laser.z_index = 5
	self.add_child(laser)

func _process(delta: float) -> void:
	current_targets = locate_targets()
	_attack(delta)

func _attack(delta: float) -> void:
	laser.clear_points()
	if not current_targets:
		sprite.play("default")
		return
	sprite.play("firing")
	for i in range(len(current_targets)):
		laser.add_point(Vector2.ZERO)
		var t: Enemy = current_targets[i]
		laser.add_point((t.global_position + Main.HALF_TILE_SIZE) - global_position)
		t.current_health -= (delta * tower_stats.damage)
