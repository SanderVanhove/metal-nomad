extends Node2D
class_name Level

export(String) var self_path = "res://Screens/Level/Level.tscn"


onready var _player = $Player
onready var _tween: Tween = $Tween
onready var _spawn: Node2D = $Spawn


func _ready() -> void:
	Composer.play()


func _process(delta: float) -> void:
	if _player._is_shooting:
		VisualServer.set_default_clear_color(Color('676975'))
	else:
		VisualServer.set_default_clear_color(Color('757575'))


func respawn() -> void:
	get_tree().change_scene(self_path)
