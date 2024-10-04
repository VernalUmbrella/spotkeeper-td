class_name TowerStats
extends Resource

enum TargetingMode {
	FIRST,
	STRONGEST,
	NONE,
}

@export_group("Visuals")
@export var texture: Texture2D
@export var attack_color: Color
@export var name: String
@export_group("Attributes")
@export var cost: int
@export var damage: float
## This property is ignored on towers with continuous firing.
@export var attacks_per_second: float
@export var attack_range: float
@export var max_targets: int
@export var targeting_mode: TargetingMode
@export var tower_script: Script
