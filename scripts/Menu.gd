extends CanvasLayer


func _on_ContinueGameButton_pressed():
	SignalManager.emit_signal("continue_game_pressed")


func _on_QuitLevelButton_pressed():
	SignalManager.emit_signal("quit_level_pressed")


func _on_QuitGameButton_pressed():
	SignalManager.emit_signal("quit_game_pressed")
