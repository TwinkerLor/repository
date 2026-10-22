extends Control

var settings_instance = null

func _ready():
	visible = false
	
func _input(event):
	if event.is_action_pressed("ui_pause"):
		visible = not visible
		if multiplayer.multiplayer_peer != null:
			GameData.is_menu_open = visible
		else:
			get_tree().paused = visible

func _on_button_pressed() -> void:
	get_tree().paused = false
	GameData.is_menu_open = false
	hide()

func _on_button_2_pressed() -> void:
	if settings_instance != null:
		return
	settings_instance = load("res://scenes/settings_menu.tscn").instantiate()
	get_tree().current_scene.add_child(settings_instance)
	settings_instance.tree_exited.connect(func(): settings_instance = null)

func _on_button_3_pressed() -> void:
	if multiplayer.multiplayer_peer != null:
		multiplayer.multiplayer_peer.close()
		multiplayer.multiplayer_peer = null
	get_tree().paused = false
	get_tree().change_scene_to_file("res://main_menu.tscn")

func _on_button_4_pressed() -> void:
	if multiplayer.multiplayer_peer != null:
		multiplayer.multiplayer_peer.close()
		multiplayer.multiplayer_peer = null
	get_tree().quit()
