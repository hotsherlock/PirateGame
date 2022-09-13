extends KinematicBody

export var foot_speed = 10
export var foot_acceleration = 5
export var run_speed_modifier = 2
export var sneak_speed_modifier = .5
export var gravity_acceleration = 75
export var jump_impulse = 30
export var swim_speed = 10
export var swim_acceleration = 2

var velocity = Vector3.ZERO
var is_sprinting = false
var is_crouched = false
var is_prone = false
var is_floating = false
var is_swimming = false
var is_diving = false
var mouse_position_x = 0
var mouse_position_y = 0
var controls_are_active = true

onready var active_camera = $GimbalCamera

func _init():
# warning-ignore:return_value_discarded
	SignalManager.connect("game_menu_opened", self, "pause_controls")
# warning-ignore:return_value_discarded
	SignalManager.connect("game_menu_closed", self, "resume_controls")
# warning-ignore:return_value_discarded
	SignalManager.connect("entered_water_surface", self, "set_floating")
# warning-ignore:return_value_discarded
	SignalManager.connect("exited_water_surface", self, "unset_floating")
# warning-ignore:return_value_discarded
	SignalManager.connect("entered_water", self, "set_swimming")
# warning-ignore:return_value_discarded
	SignalManager.connect("exited_water", self, "unset_swimming")
# warning-ignore:return_value_discarded
	SignalManager.connect("entered_under_water", self, "set_diving")
# warning-ignore:return_value_discarded
	SignalManager.connect("exited_under_water", self, "unset_diving")

func _ready():
	toggle_camera()

# main function called once per frame
func _physics_process(delta):	
	# toggle states
	if Input.is_action_just_pressed("toggle_camera"):
		toggle_camera()
	if Input.is_action_just_pressed("crouch") && !is_in_water():
		update_crouch()
		
	if(Input.is_action_pressed("sprint") && is_on_floor() && !is_in_water()):
		set_sprinting()
	elif(is_on_floor() || is_in_water()):
		unset_sprinting()
	
	# player movement
	do_movement(delta)

func do_movement(delta):
	if(!is_in_water()):
		move_on_foot(delta)
	if(is_in_water()):
		move_in_water(delta)

func move_on_foot(delta):
	var is_moving = false
	var movement_direction = Vector3.ZERO
	
	if(controls_are_active):
		if(Input.is_action_pressed("move_right")):
			movement_direction += active_camera.get_global_transform().basis.x
			is_moving = true
		if(Input.is_action_pressed("move_left")):
			movement_direction -= active_camera.get_global_transform().basis.x
			is_moving = true
		if(Input.is_action_pressed("move_back")):
			movement_direction += active_camera.get_global_transform().basis.z
			is_moving = true
		if(Input.is_action_pressed("move_forward")):
			movement_direction -= active_camera.get_global_transform().basis.z
			is_moving = true
		
		movement_direction = movement_direction.normalized() # fixes value to 0-1 range
	
	# accelerate or deaccelerate horizontally
	var acceleration = foot_acceleration
	
	if(!is_moving):
		acceleration = acceleration * 1.5
	
	# project new position based on speed
	var speed = 0
	
	if(is_prone):
		speed = foot_speed * sneak_speed_modifier * sneak_speed_modifier
	elif(is_crouched):
		speed = foot_speed * sneak_speed_modifier
	elif(is_sprinting):
		speed = foot_speed * run_speed_modifier
	else:
		speed = foot_speed
	
	if(!is_moving):
		speed = 0
		
	var new_position = movement_direction * speed
		
	# interpolate horizontal velocity based on acceleration rather than setting movement based on speed only
	var horizontal_velocity = velocity
	horizontal_velocity.y = 0
	horizontal_velocity = horizontal_velocity.linear_interpolate(new_position, acceleration * delta)
	
	# add horizontal velocity to node velocity and do movement
	velocity.x = horizontal_velocity.x
	velocity.z = horizontal_velocity.z
	
	# gravity
	if(!is_on_floor()):
		velocity.y -= gravity_acceleration * delta
	
	velocity = move_and_slide(velocity, Vector3.UP, true)
	
	#face direction of camera
	if(is_moving):
		var facing_direction = atan2(velocity.x, velocity.z)
		var player_rotation = $Pivot.get_rotation();
		player_rotation.y = facing_direction
		$Pivot.set_rotation(player_rotation)
	
	# jumping.
	if(is_on_floor() and Input.is_action_just_pressed("jump") && controls_are_active):
		velocity.y += jump_impulse
		enter_stand()

func move_in_water(delta):
	var is_moving = false
	var movement_direction = Vector3.ZERO
	
	if(controls_are_active):
		if(Input.is_action_pressed("move_right")):
			movement_direction += active_camera.get_node("CameraPivot/Camera").get_global_transform().basis.x
			is_moving = true
		if(Input.is_action_pressed("move_left")):
			movement_direction -= active_camera.get_node("CameraPivot/Camera").get_global_transform().basis.x
			is_moving = true
		if(Input.is_action_pressed("move_back")):
			movement_direction += active_camera.get_node("CameraPivot/Camera").get_global_transform().basis.z
			is_moving = true
		if(Input.is_action_pressed("move_forward")):
			movement_direction -= active_camera.get_node("CameraPivot/Camera").get_global_transform().basis.z
			is_moving = true
		if(Input.is_action_pressed("sprint")):
			movement_direction += active_camera.get_global_transform().basis.y
			is_moving = true
		if(Input.is_action_pressed("crouch")):
			movement_direction -= active_camera.get_global_transform().basis.y
			is_moving = true
		
		movement_direction = movement_direction.normalized() # fixes value to 0-1 range
	
	# accelerate or deaccelerate horizontally
	var acceleration = swim_acceleration
	
	# project new position based on speed
	var speed = swim_speed
	
	if(!is_moving):
		speed = 0
		
	var new_position = movement_direction * speed
		
	# interpolate horizontal velocity based on acceleration rather than setting movement based on speed only
	var swim_velocity = velocity	
	swim_velocity = swim_velocity.linear_interpolate(new_position, acceleration * delta)
	
	# add horizontal velocity to node velocity and do movement
	velocity.x = swim_velocity.x
	velocity.z = swim_velocity.z
	velocity.y = swim_velocity.y
	
	velocity = move_and_slide(velocity, Vector3.UP, true)
	
	#face direction of camera
	if(is_moving):
		var facing_direction_y = atan2(velocity.x, velocity.z)
		var facing_direction_x = PI * active_camera.get_node("CameraPivot/Camera").get_global_transform().basis.z.y / 2
		var player_rotation = $Pivot.get_rotation();
		player_rotation.y = facing_direction_y
		player_rotation.x = facing_direction_x
		$Pivot.set_rotation(player_rotation)
	
	# jumping.

func is_in_water():
	return is_swimming || is_diving

# mouse movement
func _input(event):
	if(controls_are_active):
		$GimbalCamera.do_camera_controls(event)
		$PlayerCamera.do_camera_controls(event)

# state management
func pause_controls():
	controls_are_active = false
	
func resume_controls():
	controls_are_active = true

func toggle_camera():
	if(active_camera == $GimbalCamera):
		$GimbalCamera/CameraPivot/Camera.current = false
		$PlayerCamera/CameraPivot/Camera.current = true
		active_camera = $PlayerCamera
	else:
		$GimbalCamera/CameraPivot/Camera.current= true
		$PlayerCamera/CameraPivot/Camera.current = false
		active_camera = $GimbalCamera

func set_sprinting():
	is_crouched = false
	is_prone = false
	is_sprinting = true
	enter_stand();
	
func unset_sprinting():
	is_sprinting = false

func update_crouch():
	if(!is_in_water() && is_on_floor() && !is_crouched && !is_prone):
		enter_crouch()
	elif(is_crouched):
		enter_prone()
	elif(is_prone):
		enter_stand()

func enter_crouch():
	is_crouched = true
	is_prone = false
	var tween_duration = .25
	var player_tween = create_tween().set_parallel()
	player_tween.set_trans(Tween.TRANS_LINEAR)
	player_tween.tween_property($Pivot/MeshInstance, "scale:y", 0.5, tween_duration)
	player_tween.tween_property($PlayerCamera, "translation:y", 1.0, tween_duration)
	player_tween.tween_property($PlayerCamera, "translation:z", 0.0, tween_duration)
	player_tween.tween_property($Pivot, "rotation_degrees:x", -90.0, tween_duration)
	
func enter_prone():
	is_crouched = false
	is_prone = true
	var tween_duration = .25
	var player_tween = create_tween().set_parallel()
	player_tween.set_trans(Tween.TRANS_LINEAR)
	player_tween.tween_property($Pivot/MeshInstance, "scale:y", 1.0, tween_duration)
	player_tween.tween_property($PlayerCamera, "translation:y", 0.75, tween_duration)
	player_tween.tween_property($PlayerCamera, "translation:z", 0.5, tween_duration)
	player_tween.tween_property($Pivot, "rotation_degrees:x", 0.0, tween_duration)

func enter_stand():
	is_crouched = false
	is_prone = false
	var tween_duration = .25
	var player_tween = create_tween().set_parallel()
	player_tween.set_trans(Tween.TRANS_LINEAR)
	player_tween.tween_property($Pivot/MeshInstance, "scale:y", 1.0, tween_duration)
	player_tween.tween_property($PlayerCamera, "translation:y", 1.5, tween_duration)
	player_tween.tween_property($PlayerCamera, "translation:z", 0.0, tween_duration)
	player_tween.tween_property($Pivot, "rotation_degrees:x", -90.0, tween_duration)

func set_floating():
	is_floating = true

func unset_floating():
	is_floating = false

func set_swimming():
	is_sprinting = false
	is_crouched = false
	is_swimming = true
	enter_prone()

func unset_swimming():
	is_swimming = false
	enter_stand()

func set_diving():
	is_sprinting = false
	is_crouched = false
	is_diving = true

func unset_diving():
	is_diving = false
