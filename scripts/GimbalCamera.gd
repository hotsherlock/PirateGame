extends Spatial

func do_camera_controls(event):
	if(event is InputEventMouseMotion):
		rotate_y(-event.relative.x * 0.001)
		if(event.relative.y > 0 && $CameraPivot.rotation.x > -PI/2):
			$CameraPivot.rotate_x(-event.relative.y  * 0.001)
		if(event.relative.y < 0 && $CameraPivot.rotation.x < PI/2):
			$CameraPivot.rotate_x(-event.relative.y * 0.001)
	if(event is InputEventMouseButton):
		if(event.is_pressed()):
			# zoom in
			if(event.button_index == BUTTON_WHEEL_UP):
				if($CameraPivot/Camera.transform.origin.z > 2):
					$CameraPivot/Camera.transform.origin.z -= .5
			# zoom out
			if(event.button_index == BUTTON_WHEEL_DOWN):
				if($CameraPivot/Camera.transform.origin.z < 10):
					$CameraPivot/Camera.transform.origin.z += .5
	
