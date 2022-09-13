extends Spatial

func _on_WaterSurface_body_entered(body):
	if(body is KinematicBody):
		SignalManager.emit_signal("entered_water_surface")
		print("entered_water_surface")

func _on_WaterSurface_body_exited(body):
	if(body is KinematicBody):
		SignalManager.emit_signal("exited_water_surface")
		print("exited_water_surface")

func _on_Water_body_entered(body):
	if(body is KinematicBody):
		SignalManager.emit_signal("entered_water")
		print("entered_water")

func _on_Water_body_exited(body):
	if(body is KinematicBody):
		SignalManager.emit_signal("exited_water")
		print("exited_water")

func _on_UnderWater_body_entered(body):
	if(body is KinematicBody):
		SignalManager.emit_signal("entered_under_water")
		print("entered_under_water")

func _on_UnderWater_body_exited(body):
	if(body is KinematicBody):
		SignalManager.emit_signal("exited_under_water")
		print("exited_under_water")
