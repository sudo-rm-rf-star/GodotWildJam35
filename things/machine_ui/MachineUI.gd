extends CanvasLayer
class_name MachineUI


signal influence_changed(value)


export(String) var machine_name: String = "Stone Hendge" setget set_machine_name
export(String, MULTILINE) var flavour_text: String


onready var _tween: Tween = $Tween
onready var _container: Control = $CenterContainer
onready var _name_label: Label = $CenterContainer/PanelContainer/MarginContainer/VBoxContainer/VBoxContainer/PanelContainer/MachineName
onready var _click_audio: AudioStreamPlayer = $Click


func set_machine_name(new_machine_name: String):
	machine_name = new_machine_name
	_name_label.text = machine_name


func activate():
	_container.show()
	_tween.remove_all()
	_tween.interpolate_property(_container, "modulate:a", 0, 1, .4)
	_tween.start()


func deactivate():
	_tween.remove_all()
	_tween.interpolate_property(_container, "modulate:a", _container.modulate.a, 0, .4)
	_tween.start()
	
	yield(_tween, "tween_all_completed")
	
	if _container.modulate.a == 0:
		_container.hide()


func _on_HSlider_value_changed(value):
	_click_audio.play()
	print(machine_name, " new influence: ", value)
	emit_signal("influence_changed", value)
