extends Node

export var time_scale = 48

onready var time_paused = false;

func _init():
# warning-ignore:return_value_discarded
	SignalManager.connect("continue_game_pressed", self, "close_menu")
# warning-ignore:return_value_discarded
	SignalManager.connect("game_menu_opened", self, "pause_time")
# warning-ignore:return_value_discarded
	SignalManager.connect("game_menu_closed", self, "resume_time")

# capture mouse in window
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
# warning-ignore:unused_argument
func _process(delta):
	if Input.is_action_just_pressed("toggle_menu"):
		if($Menu.visible):
			close_menu()
		else:
			open_menu()
			
	if(!time_paused):
		$LightPivot/DirectionalLight.rotation_degrees.x -= (delta / 240) * time_scale
		if($LightPivot/DirectionalLight.rotation_degrees.x > 360):
			$LightPivot/DirectionalLight.rotation_degrees.x -= 360

func open_menu():
	$Menu.visible = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	SignalManager.emit_signal("game_menu_opened")
	
func close_menu():
	$Menu.visible = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	SignalManager.emit_signal("game_menu_closed")
	
func pause_time():
	time_paused = false

func resume_time():
	time_paused = true
