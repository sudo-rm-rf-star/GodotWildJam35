extends StaticBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var destination: Vector2 = position

export(NodePath) var start_path: NodePath
onready var start: Vector2 = get_node(start_path).position

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func set_influence(value):
	position = lerp(start, destination, value)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
