extends Node2D

signal player_arrived




func _on_Area2D_body_entered(body: Node) -> void:
	if body as Player:
		emit_signal("player_arrived")
