extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export var _speed: int = 100
export(NodePath) var _center_object: NodePath

export(float) var gravity: float = 1000.0


var _center: Vector2 = Vector2.ZERO

var _velocity = Vector2()

# Called when the node enters the scene tree for the first time.
func _ready():
	_center = get_node(_center_object).position
	
func _physics_process(delta):
	var _direction = move_direction()
	var up: Vector2 = (_center - position).normalized()
	
	_velocity.x += _direction.x * _speed
	_velocity += gravity * delta * up
	_velocity = move_and_slide(_velocity, up)
	
	rotate(get_angle_to(_center) + PI / 2)
	
func move_direction() -> Vector2:
	return Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		0
	)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
