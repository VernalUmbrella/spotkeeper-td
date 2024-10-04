class_name TowerButton
extends TextureButton

@export var tower_stats: TowerStats

func _ready() -> void:
	if not tower_stats:
		var placeholder = GradientTexture2D.new() # TODO remove
		placeholder.width = 8
		placeholder.height = 8
		texture_normal = placeholder
		return
	if tower_stats.texture:
		texture_normal = tower_stats.texture

func _pressed() -> void:
	Events.tower_selected.emit(tower_stats)
