extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export(NodePath) var _center_object: NodePath
var _center: Vector2

# Called when the node enters the scene tree for the first time.
func _ready():
	_center = get_node(_center_object).position
	
func _process(delta):
	for child in get_children():
			var new_rotation: float = child.get_angle_to(_center) - PI / 2
			child.rotate(new_rotation)
		


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
