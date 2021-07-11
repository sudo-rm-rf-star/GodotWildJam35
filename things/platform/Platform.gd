extends StaticBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var destination: Vector2 = position

onready var start: Vector2 = to_global($Start.position)
onready var _tween: Tween = $Tween

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func set_influence(value):
	var new_position = lerp(start, destination, value)
	_tween.remove_all()
	_tween.interpolate_property(self, "position", position, new_position, .5, Tween.TRANS_BACK, Tween.EASE_OUT)
	_tween.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
