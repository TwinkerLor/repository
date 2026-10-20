extends Control

func _ready():
	visible = false
	
func _input(event):
	if event.is_action_pressed("ui_pause"):
		visible = not visible
		get_tree().paused = visible

func _on_button_pressed() -> void:
	get_tree().paused = false
	hide()

func _on_button_2_pressed() -> void:
	pass # Replace with function body.

func _on_button_3_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://main_menu.tscn")

func _on_button_4_pressed() -> void:
	get_tree().quit()
