extends CanvasLayer

func _ready():
	var tween_duration = 10
	var label_tween = create_tween()
	label_tween.set_trans(Tween.TRANS_LINEAR)
	
	label_tween.tween_property($ColorRect/Credits, "rect_position:y", -600.0, tween_duration)	
	label_tween.tween_callback(self, "end_scene", [])
	
func end_scene():
	SignalManager.emit_signal("credit_screen_end")
