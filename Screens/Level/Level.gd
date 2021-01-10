extends Node2D
class_name Level

export(String) var self_path = "res://Screens/Level/Level.tscn"
export(String) var next_level = "res://Screens/Level/Level.tscn"
export(AudioStreamSample) onready var win_text
export(String) var day_number = "   One"
export(bool) var ends_game = false


onready var _player = $Player
onready var _tween: Tween = $Tween
onready var _spawn: Node2D = $Spawn
onready var _end_player: AudioStreamPlayer = $AudioStreamPlayer
onready var _rooster_player: AudioStreamPlayer = $Rooster
onready var _text: ColorRect = $ColorRect


func _ready() -> void:
	Composer.reset()

	$ColorRect/Label.text = "Day " + day_number
	_tween.interpolate_property(_text, 'modulate:a', 0, 1, 1.5)
	_tween.interpolate_property(_text, 'modulate:a', 1, 0, 2, 0, 2, 1)
	_tween.start()
	_rooster_player.play()

	yield(_tween, "tween_all_completed")

	_player._is_dead = false
	Composer.play()


func _process(delta: float) -> void:
	if _player._is_shooting:
		VisualServer.set_default_clear_color(Color('676975'))
	else:
		VisualServer.set_default_clear_color(Color('757575'))


func respawn() -> void:
	get_tree().change_scene(self_path)


func _on_Oasis_player_arrived() -> void:
	if ends_game:
		return
	_player._is_dead = true
	_end_player.stream = win_text
	_end_player.play()

	_tween.interpolate_property(self, 'modulate', modulate, modulate.darkened(1), 2)
	_tween.start()

	Composer.stop()

	yield(_end_player, "finished")

	get_tree().change_scene(next_level)
