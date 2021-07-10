extends Node2D


onready var _ui: MachineUI = $MachineUI
onready var _tween: Tween = $Tween

onready var _camera: Camera = get_viewport().get_camera()

var _saved_camera_zoom: Vector2
var _zoom_out: Vector2 = Vector2(3, 3)

export(Array, NodePath) var influencees: Array

func _on_Area2D_body_entered(body: PhysicsBody2D):
	if not body.is_in_group("player"):
		return
	
	var camera = body.camera
	
	_ui.activate()
	
	_saved_camera_zoom = camera.zoom
	
	_tween.remove_all()
	_tween.interpolate_property(camera, "zoom", camera.zoom, _zoom_out, .4, Tween.TRANS_SINE)
	_tween.interpolate_property(camera, "position", Vector2.ZERO, body.to_local(body._center), .4, Tween.TRANS_BACK)
	_tween.start()


func _on_Area2D_body_exited(body):
	if not body.is_in_group("player"):
		return
	
	var camera = body.camera
	
	_ui.deactivate()
	
	_tween.remove_all()
	_tween.interpolate_property(camera, "zoom", camera.zoom, _saved_camera_zoom, .4, Tween.TRANS_SINE)
	_tween.interpolate_property(camera, "position", camera.position, Vector2.ZERO, .4, Tween.TRANS_BACK)
	_tween.start()
	

