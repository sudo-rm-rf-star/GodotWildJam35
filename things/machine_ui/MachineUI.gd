extends CanvasLayer
class_name MachineUI


signal influence_changed(value)


export(String) var machine_name: String = "Stone Hendge"
export(String, MULTILINE) var flavour_text: String


onready var _tween: Tween = $Tween
onready var _container: Control = $CenterContainer


func activate():
	_container.show()
	_tween.interpolate_property(_container, "modulate:a", 0, 1, .4)
	_tween.start()


func deactivate():
	_tween.interpolate_property(_container, "modulate:a", _container.modulate.a, 0, .4)
	_tween.start()
	
	yield(_tween, "tween_all_completed")
	
	_container.hide()


func _on_HSlider_value_changed(value):
	print(machine_name, " new influence: ", value)
	emit_signal("influence_changed", value)
