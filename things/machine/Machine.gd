extends Node2D

export(Texture) var machine_sprite: Texture
export(String) var machine_name: String
export(String, MULTILINE) var flavor_text: String
export(AudioStream) var audio: AudioStream
export(float, 0, 1, 0.2) var initial_influence = 0.0

onready var _ui: MachineUI = $MachineUI
onready var _tween: Tween = $Tween
onready var _sprite: Sprite = $Sprite
onready var _dialog: DialogUI = $DialogUI
onready var _on_audio: AudioStreamPlayer = $On
onready var _off_audio: AudioStreamPlayer = $Off


var _saved_camera_zoom: Vector2
var _zoom_out: Vector2 = Vector2(6.5, 6.5)

export(Array, NodePath) var influencees_paths: Array
var influencees 


func _ready():
	_sprite.texture = machine_sprite
	_ui.init(machine_name, initial_influence)
	
	_dialog.text = flavor_text
	_dialog.title = machine_name
	_dialog.audio = audio


func _process(delta):
	if not influencees:
		influencees = Array()
		for influencee_path in influencees_paths:
			var influencee = get_node(influencee_path)
			influencees.append(influencee)
		_on_MachineUI_influence_changed(initial_influence)


func _on_Area2D_body_entered(body: PhysicsBody2D):
	if not body.is_in_group("player"):
		return
	
	if is_instance_valid(_dialog):
		_dialog.activate()
		yield(_dialog, "dismissed")
		
	_on_audio.play()
	
	_ui.activate()
	
	var camera = body.camera
	_saved_camera_zoom = camera.zoom
	
	_tween.remove_all()
	_tween.interpolate_property(camera, "zoom", camera.zoom, _zoom_out, .4, Tween.TRANS_SINE)
	_tween.interpolate_property(camera, "position", Vector2.ZERO, body.to_local(body._center), .4, Tween.TRANS_BACK)
	_tween.start()


func _on_Area2D_body_exited(body):
	if not body.is_in_group("player"):
		return
	
	if is_instance_valid(_dialog):
		_dialog.deactivate()
		return
	
	_off_audio.play()

	_ui.deactivate()
	
	var camera = body.camera
	_tween.remove_all()
	_tween.interpolate_property(camera, "zoom", camera.zoom, _saved_camera_zoom, .4, Tween.TRANS_SINE)
	_tween.interpolate_property(camera, "position", camera.position, Vector2.ZERO, .4, Tween.TRANS_BACK)
	_tween.start()
	



func _on_MachineUI_influence_changed(value):
	if not influencees:
		return
		
	for influencee in influencees:
		influencee.set_influence(value)

