extends Node2D

@onready var players_container = $Player

func _ready() -> void:
	spawn_player()

func spawn_player() -> void:
	var scene_path = GameData.selected_character_path
	var player = load(scene_path).instantiate()
	players_container.add_child(player)
