extends Node2D


func _on_Area2D_body_entered(body):
	if not body.is_in_group("player"):
		return
	$Wolkjes.position = to_local(body.position)
	$Wolkjes.rotation = body.rotation
	$Wolkjes.emitting = true
	body.die()

