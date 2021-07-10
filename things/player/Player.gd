extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export var _speed: int = 400

var _velocity = Vector2()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	
func _physics_process(delta):
	var _direction = move_direction()
	_velocity = move_and_slide(_velocity)
	_velocity.x = _direction.x * _speed
	
func move_direction() -> Vector2:
	return Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		0
	)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
