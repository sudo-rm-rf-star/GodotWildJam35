extends Node



var _parent: KinematicBody2D
var _motion: Vector2 = Vector2.ZERO


func _ready():
	_parent = get_parent()


func _physics_process(delta):
	if not _center and center_object:
		_center = get_node(center_object).position
	if not _center:
		return
		

