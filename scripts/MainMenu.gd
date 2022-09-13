extends CanvasLayer

func _on_StartGameButton_pressed():
	SignalManager.emit_signal("start_game_pressed")

func _on_CreditsButton_pressed():
	SignalManager.emit_signal("view_credits_pressed")

func _on_QuitButton_pressed():
	SignalManager.emit_signal("quit_game_pressed")
