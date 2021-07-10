extends Node2D


func _on_Area2D_body_entered(body):
	if not body.is_in_group("player"):
		return
	
	body.die()
