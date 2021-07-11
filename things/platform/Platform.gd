extends StaticBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export var _destination: Vector2

onready var _tween: Tween = $Tween

onready var _start: Vector2 = position

export var _radius: float = 900
export var _index: float
export var _total: float = 9

var _center: Vector2

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _process(delta):
	var angle = get_angle_to(_center)
	var new_rotation: float = angle - PI / 2
	rotate(new_rotation)

func set_center(center):
	_center = center
	var slice =  2*PI/_total
	var angle = slice * _index - PI/2
	printt(slice, angle)
	_destination = Vector2(
		_center.x + cos(angle)*_radius,
		_center.y + sin(angle)*_radius

	)

func set_influence(value):
	var new_position = lerp(_start, _destination, value)
	_tween.remove_all()
	_tween.interpolate_property(self, "position", position, new_position, .5, Tween.TRANS_BACK, Tween.EASE_OUT)
	_tween.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
