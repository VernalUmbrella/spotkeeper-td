class_name RailgunTower
extends Tower

@export var shot_duration: float = 0.8

var attack_timer: Timer
var shot: Line2D

func _ready() -> void:
	super._ready()
	attack_timer = Timer.new()
	attack_timer.wait_time = 1.0 / tower_stats.attacks_per_second
	attack_timer.one_shot = true
	add_child(attack_timer)
	shot = Line2D.new()
	shot.default_color = tower_stats.attack_color
	shot.width = 2
	add_child(shot)

func _process(delta: float) -> void:
	current_targets = locate_targets()
	_attack(delta)

func _attack(_delta: float) -> void:
	if not attack_timer.is_stopped() or not current_targets:
		return
	attack_timer.start()
	shot.clear_points()
	for t: Enemy in current_targets:
		shot.add_point(Vector2.ZERO)
		shot.add_point(t.global_position + Main.HALF_TILE_SIZE - global_position)
		t.current_health -= tower_stats.damage
	var shot_tween := create_tween()
	shot_tween.tween_property(shot, "modulate", Color.TRANSPARENT, shot_duration).from(Color.WHITE)
