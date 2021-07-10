extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export var _speed: int = 200
export var _max_speed: float = 250.0
export(float) var _jump_strength: float = 300
export(NodePath) var _center_object: NodePath

export(float) var gravity: float = 300.0


var _center: Vector2 = Vector2.ZERO

var _velocity = Vector2.ZERO
var _up: Vector2 = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
	_center = get_node(_center_object).position


func _physics_process(delta):
	var new_rotation: float = get_angle_to(_center) - PI / 2
	rotate(new_rotation)
	_up = Vector2.UP.rotated(new_rotation)
	print(_center)
	
	var movement: Vector2 = Vector2.ZERO
	
	# Gravity
	movement.y += gravity * delta
	
	# X movement
	movement += handle_sideways_movement(delta)
	# Jumping
	movement += handle_jump()
	
	_velocity += movement.rotated(rotation)
	
	$Line2D.points = PoolVector2Array([Vector2(0, 0), _up * 100])
	
	_velocity = move_and_slide(_velocity, _up)


func handle_jump() -> Vector2:
		
	if not Input.is_action_just_pressed("jump"):
		return Vector2.ZERO
	
	return Vector2(0, -_jump_strength)
	
	
func handle_sideways_movement(delta) -> Vector2:
	var _direction: Vector2 = Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		0
	)
	
	return _direction * _speed * delta
