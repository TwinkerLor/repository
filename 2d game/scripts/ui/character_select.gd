extends Control

@onready var bgs = [$background, $Background2, $Background3]
@onready var timer = $Timer

var current = 0

func _ready() -> void:
	for i in range(bgs.size()):
		bgs[i].visible = (i == 0)
	timer.timeout.connect(_change_background)
	
func _change_background():
	bgs[current].visible = false
	current = (current + 1) % bgs.size()
	bgs[current].visible = true

func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://main_menu.tscn")


func _on_select_pressed() -> void:
	GameData.selected_character_path = "res://scripts/player.gd/character_body_2d.tscn"
	get_tree().change_scene_to_file("res://level.tscn")


func _on_select_2_pressed() -> void:
	GameData.selected_character_path = "res://scripts/player.gd/player_2.tscn"
	get_tree().change_scene_to_file("res://level.tscn")
