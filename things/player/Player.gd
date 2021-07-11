extends KinematicBody2D


export var _friction_floor: float = .2
export var _friction_air: float = .01
export var _speed_stop: float = 50
export var _speed: int = 1000
export var _max_speed: float = 350.0
export(float) var _jump_strength: float = 600
export(NodePath) var _center_object: NodePath

export(float) var gravity: float = 1000.0


var _center: Vector2 = Vector2.ZERO

var _velocity = Vector2.ZERO
var _up: Vector2 = Vector2.ZERO
var _was_in_air: bool = false
var _is_jumping: bool = false
var _can_jump: bool = false
onready var _last_safe_location: Vector2 = position

onready var _animation_player: AnimationPlayer = $AnimationPlayer
onready var _jump_animation_player: AnimationPlayer = $JumpAnimationPlayer
onready var _coyote_timer: Timer = $CoyoteTimer
onready var _death_timer: Timer = $DeathTimer
onready var camera: Camera2D = $Camera2D

# Called when the node enters the scene tree for the first time.
func _ready():
	_center = get_node(_center_object).position


func _physics_process(delta):
	_up = (position - _center).normalized()

	$Up.points = PoolVector2Array([Vector2(), _up*100])

	var angle = get_angle_to(_center)
	var new_rotation: float = angle - PI / 2
	rotate(new_rotation)


	
	var movement: Vector2 = Vector2.ZERO
	var relative_velocity = _velocity.rotated(-rotation)
#	print(relative_velocity)
	$Velocity.points = PoolVector2Array([Vector2(0, 0), relative_velocity])
	
	# Friction
	var friction = _friction_air
	if is_on_floor() and not (Input.is_action_pressed("move_right") or Input.is_action_pressed("move_left")):
		friction = _friction_floor
		
		if abs(relative_velocity.x) < _speed_stop:
			friction = 1
			
#	printt(abs(relative_velocity.x), friction)
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
	
	var upright_velocity = _velocity.rotated(-rotation)
	upright_velocity += movement
	
	upright_velocity.x = clamp(upright_velocity.x, -_max_speed, _max_speed)

	_velocity = upright_velocity.rotated(rotation)
	
	handle_animations()
	
	if not _was_in_air and not is_on_floor():
		_coyote_timer.start()
		
	_was_in_air = !is_on_floor()
	
	# Save location if it is safe
	if is_on_floor():
		_last_safe_location = position
	
	_velocity = move_and_slide(_velocity, _up)

#	print(_velocity)


func handle_jump() -> Vector2:
	if not Input.is_action_just_pressed("jump"):
		return Vector2.ZERO
	if not is_on_floor() and _coyote_timer.is_stopped():
		return Vector2.ZERO
	
	_is_jumping = true
	return Vector2(0, -_jump_strength)


func handle_sideways_movement(delta: float, relative_velocity: Vector2) -> Vector2:
	var _direction: Vector2 = Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		0
	)
	
	return _direction * _speed * delta


func handle_animations():
	if is_on_floor() and Input.is_action_just_pressed("jump"):
		_jump_animation_player.play("jump")
		_animation_player.play("reset")
	elif is_on_floor() and _was_in_air:
		_animation_player.play("reset")
		_jump_animation_player.play("land")
	elif is_on_floor() and (Input.is_action_pressed("move_right") or Input.is_action_pressed("move_left")):
		_animation_player.play("walk")
	elif is_on_floor() and not _jump_animation_player.is_playing():
		_animation_player.play("idle")
	

func die():
	_death_timer.start()
	yield(_death_timer, "timeout")
	position = _last_safe_location
	_velocity = Vector2.ZERO
