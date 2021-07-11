extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export var _destination: Vector2

onready var _influence: Tween = $InfluenceTween
onready var _hover: Tween = $HoverTween

onready var _start: Vector2 = position

export var _radius: float = 900
export var _index: float
export var _total: float = 9
export var _max_hover: float = 40

var _hover_direction: float = 1
var _center: Vector2
var _influence_value: float = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	do_hover()

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

func do_hover():
	var hover_range = Vector2(0, _max_hover * (1 - _influence_value)).rotated(rotation)
	_hover.remove_all()
	_hover.interpolate_property(
		self,
		"position",
		position,
		position-hover_range*_hover_direction,
		2,
		Tween.TRANS_SINE,
		Tween.EASE_IN_OUT
	)
	_hover_direction = -_hover_direction
	_hover.start()

func set_influence(value):
	if value == 1:
		$Sterretjes.emitting = true
	var new_position = lerp(_start, _destination, value)
	_influence_value = value
	_hover.remove_all()
	_influence.remove_all()
	_influence.interpolate_property(self, "position", position, new_position, .5, Tween.TRANS_BACK, Tween.EASE_OUT)
	_influence.start()
	



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_HoverTween_tween_completed(object, key):
	do_hover()


func _on_InfluenceTween_tween_completed(object, key):
	do_hover()
