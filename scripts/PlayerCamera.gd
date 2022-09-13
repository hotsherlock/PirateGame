extends Spatial

func do_camera_controls(event):
	if(event is InputEventMouseMotion):
		rotate_y(-event.relative.x * 0.001)
		if(event.relative.y > 0 && $CameraPivot.rotation.x > -PI/2):
			$CameraPivot.rotate_x(-event.relative.y  * 0.001)
		if(event.relative.y < 0 && $CameraPivot.rotation.x < PI/2):
			$CameraPivot.rotate_x(-event.relative.y * 0.001)
