extends Node

var current_scene = null
		
func goto_scene(path):
	call_deferred("_deferred_goto_scene",path)


func _deferred_goto_scene(path):
	# Immediately free the current scene,
	# there is no risk here.
	if(current_scene != null):
		current_scene.free()

	# Load new scene
	var s = ResourceLoader.load(path)

	# Instance the new scene
	current_scene = s.instance()

	# Add it to the active scene, as child of root
	get_tree().get_root().add_child(current_scene)

	# optional, to make it compatible with the SceneTree.change_scene() API
	get_tree().set_current_scene( current_scene )
