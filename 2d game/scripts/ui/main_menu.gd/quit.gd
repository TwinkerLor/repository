extends Button

func _on_pressed():
	get_tree().quit()


func _on_play_pressed():
	get_tree().change_scene_to_file("res://level.tscn")



func _on_coop_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn/coop_scene.tscn")
