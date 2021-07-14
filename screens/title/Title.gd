extends Node2D


func _on_Button_pressed():
	get_tree().change_scene("res://screens/game/Game.tscn")


func _on_Label2_gui_input(event):
	if event as InputEventMouseButton and not event.is_pressed():
		OS.shell_open("https://twitter.com/RienMaertens")


func _on_Label3_gui_input(event):
	if event as InputEventMouseButton and not event.is_pressed():
		OS.shell_open("https://twitter.com/CharlotteParre")


func _on_Label5_gui_input(event):
	if event as InputEventMouseButton and not event.is_pressed():
		OS.shell_open("https://twitter.com/JarreKnockaert")


func _on_Label4_gui_input(event):
	if event as InputEventMouseButton and not event.is_pressed():
		OS.shell_open("https://twitter.com/SanderVhove")


func _on_Label8_gui_input(event: InputEvent) -> void:
	if event as InputEventMouseButton and not event.is_pressed():
		OS.shell_open("https://www.patreon.com/sandervanhove")
