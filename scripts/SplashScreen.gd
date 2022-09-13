extends CanvasLayer

func _ready():
	var tween_duration = 3
	var label_tween = create_tween()
	label_tween.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
	
	label_tween.tween_property($GodotLicense, "modulate:a", 255.0, tween_duration)	
	label_tween.tween_property($GodotLicense, "modulate:a", 0.0, tween_duration)	
	label_tween.tween_property($mbedTLSLicense, "modulate:a", 255.0, tween_duration)
	label_tween.tween_property($mbedTLSLicense, "modulate:a", 0.0, tween_duration)
	label_tween.tween_callback(self, "end_scene", [])
	
func end_scene():
	SignalManager.emit_signal("splash_screen_end")
