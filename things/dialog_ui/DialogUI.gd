extends CanvasLayer
class_name DialogUI

signal dismissed


export(String, MULTILINE) var text
export(String) var title
export(AudioStream) var audio


onready var _text_box: RichTextLabel = $CenterContainer/PanelContainer/MarginContainer/VBoxContainer/VBoxContainer/Text
onready var _title: Label = $CenterContainer/PanelContainer/MarginContainer/VBoxContainer/VBoxContainer/PanelContainer/MachineName
onready var _tween: Tween = $Tween
onready var _audio: AudioStreamPlayer = $AudioStreamPlayer
onready var _container: Control = $CenterContainer
onready var _click_player: AudioStreamPlayer = $Click


func activate():
	_text_box.text = text
	_title.text = title
	_audio.stream = audio
	
	_audio.seek(0)
	_audio.play()
	
	_container.show()
	_tween.remove_all()
	_tween.interpolate_property(_container, "modulate:a", 0, 1, .4)
	_tween.start()


func deactivate():
	_audio.stop()
	_tween.remove_all()
	_tween.interpolate_property(_container, "modulate:a", _container.modulate.a, 0, .4)
	_tween.start()
	
	yield(_tween, "tween_all_completed")
	
	if _container.modulate.a == 0:
		_container.hide()


func _on_CenterContainer_gui_input(event):
	if not event as InputEventMouseButton:
		return
	
	_tween.remove_all()
	_tween.interpolate_property(_container, "modulate:a", _container.modulate.a, 0, .4)
	_tween.start()
	
	_click_player.play()
	
	yield(_tween, "tween_all_completed")
	emit_signal("dismissed")
	queue_free()
