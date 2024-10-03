class_name GameStats
extends Resource

@export var money: int = 20:
	set(value):
		assert(value >= 0)
		if money == value:
			return
		money = value
		emit_changed()
@export var lives_left: int = 10:
	set(value):
		if lives_left == value:
			return
		lives_left = value
		if lives_left <= 0:
			Events.game_lost.emit()
		emit_changed()
@export var wave_sequence: Array[Wave]
@export var current_wave: int = 0:
	set(value):
		if current_wave == value:
			return
		current_wave = value
		emit_changed()
