extends Node


export(NodePath) var center_object: NodePath
export(float) var gravity: float = 1000.0


var _center: Vector2 = Vector2.ZERO
var _parent: KinematicBody2D
var _motion: Vector2 = Vector2.ZERO


func _ready():
	_center = get_node(center_object).position
	_parent = get_parent()


func _physics_process(delta):
	var up: Vector2 = (_center - _parent.position).normalized()
	
	_motion += gravity * delta * up
	_motion = _parent.move_and_slide(_motion, up)
	
	_parent.rotate(_parent.get_angle_to(_center) + PI / 2)
