extends Node2D

onready var _flyer: Sprite = $flyer
onready var _tween: Tween = $Tween
onready var _audio: AudioStreamPlayer = $AudioStreamPlayer
onready var _label: Label = $Label


func _ready() -> void:
	_audio.play()
	_tween.interpolate_property(_flyer, "position", Vector2(-500, 400), _flyer.position, 1, Tween.TRANS_BOUNCE, Tween.EASE_OUT)
	_tween.interpolate_property(_label, "modulate:a", 0, 1, .8)
	_tween.interpolate_property(self, "modulate", modulate, modulate.darkened(1), .8, 0, 2, 8)
	_tween.start()

	yield(_tween, "tween_all_completed")

	get_tree().change_scene("res://Screens/Level/Level1.tscn")
