extends Level


func _on_Area2D2_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event.is_action_pressed("click"):
		OS.shell_open("https://twitter.com/SanderVhove")


func _on_player_arrived() -> void:
	_end_player.stream = win_text
	_end_player.play()

