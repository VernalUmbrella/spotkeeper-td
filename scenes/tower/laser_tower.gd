class_name LaserTower
extends Tower

@onready var laser: Line2D = $Laser

func _ready() -> void:
	super._ready()
	laser.default_color = tower_stats.attack_color
	laser.add_point(Main.HALF_TILE_SIZE)
	laser.add_point(Main.HALF_TILE_SIZE)
	laser.visible = false

func _process(delta: float) -> void:
	current_targets = locate_targets()
	_attack(delta)

func _attack(delta: float) -> void:
	assert(tower_stats.max_targets == 1) # TODO: implement multi-targeting
	if not current_targets:
		laser.visible = false
		return
	laser.visible = true
	for t: Enemy in current_targets:
		laser.points[1] = (t.global_position + Main.HALF_TILE_SIZE) - global_position
		t.current_health -= (delta * tower_stats.damage)
