extends Node

func _init():
# warning-ignore:return_value_discarded
	SignalManager.connect("splash_screen_end", self, "goto_main_menu")
# warning-ignore:return_value_discarded
	SignalManager.connect("start_game_pressed", self, "start_game")
# warning-ignore:return_value_discarded
	SignalManager.connect("view_credits_pressed", self, "view_credits")
# warning-ignore:return_value_discarded
	SignalManager.connect("quit_game_pressed", self, "quit_game")
# warning-ignore:return_value_discarded
	SignalManager.connect("quit_level_pressed", self, "goto_main_menu")
# warning-ignore:return_value_discarded
	SignalManager.connect("credit_screen_end", self, "goto_main_menu")

func _ready():
	SceneManager.goto_scene("scenes/SplashScreen.tscn")

func goto_main_menu():
	SceneManager.goto_scene("scenes/MainMenu.tscn")

func start_game():
	SceneManager.goto_scene("scenes/Level.tscn")
	
func view_credits():
	SceneManager.goto_scene("scenes/Credits.tscn")

func quit_game():
	get_tree().quit()
