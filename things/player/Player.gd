extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export var _friction_floor: float = .1
export var _friction_air: float = .01
export var _speed_stop: float = 1
export var _speed: int = 800
export var _max_speed: float = 250.0
export(float) var _jump_strength: float = 300
export(NodePath) var _center_object: NodePath

export(float) var gravity: float = 600.0


var _center: Vector2 = Vector2.ZERO

var _velocity = Vector2.ZERO
var _up: Vector2 = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
	_center = get_node(_center_object).position


func _physics_process(delta):
	var new_rotation: float = get_angle_to(_center) - PI / 2
	rotate(new_rotation)
	_up = -Vector2.UP.rotated(new_rotation)
	
	var movement: Vector2 = Vector2.ZERO
	var relative_velocity =  _velocity.rotated(-rotation)
	print(relative_velocity)
	$Velocity.points = PoolVector2Array([Vector2(0, 0), relative_velocity])
	
	# Friction
	var friction = _friction_air
	if abs(relative_velocity.x) < _speed_stop:
		friction = 1
	elif is_on_floor():
		friction = _friction_floor
	movement.x = -relative_velocity.x * friction

	# Gravity
	var down_force: float = gravity * delta
	movement.y += down_force
	$Gravity.points = PoolVector2Array([Vector2(0, 0), Vector2(0, down_force * 10)]) 
	
	# X movement
	var sideways = handle_sideways_movement(delta, relative_velocity)
	$Sideways.points = PoolVector2Array([Vector2(0, 0), sideways * 10])
	movement += sideways
	
	# Jumping
	var jump = handle_jump()
	$Jump.points = PoolVector2Array([Vector2(0, 0), jump * 10])
	movement += jump
	
	
	if is_on_floor():
		print("FLOOR")
	if is_on_wall():
		print("WALL")
	if is_on_ceiling():
		print("CEILING")
	
	var _rotated_movement = movement.rotated(rotation)

	_velocity += _rotated_movement
	_velocity = move_and_slide(_velocity, _up)
	print(_velocity)



func handle_jump() -> Vector2:
		
	if not Input.is_action_just_pressed("jump"):
		return Vector2.ZERO
	
	return Vector2(0, -_jump_strength)
	
	
func handle_sideways_movement(delta: float, relative_velocity: Vector2) -> Vector2:
	var _direction: Vector2 = Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		0
	)
	
	return _direction * _speed * delta
