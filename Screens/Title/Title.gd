extends Node2D


func _ready() -> void:
	VisualServer.set_default_clear_color("222034")


func _on_Button_pressed() -> void:
	get_tree().change_scene("res://Screens/Intro/Intro.tscn")
