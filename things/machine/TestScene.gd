extends Node2D


func _unhandled_input(event):
	if not event as InputEventMouseButton:
		return
	
	
	$MockPlayer.position = event.position
