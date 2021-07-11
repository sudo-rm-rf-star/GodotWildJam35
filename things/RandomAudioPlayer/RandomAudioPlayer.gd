extends Node2D
class_name RandomStreamPlayer


func play(delay: float = 0):
	yield(get_tree().create_timer(rand_range(0, delay)), "timeout")
	var random_stream: int = floor(rand_range(0, get_child_count()))

	get_child(random_stream).play()
