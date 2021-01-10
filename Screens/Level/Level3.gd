extends Level


func _on_Oasis_player_arrived() -> void:
	_end_player.stream = win_text
	_end_player.play()

