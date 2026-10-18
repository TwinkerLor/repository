extends Node2D

func _ready() -> void:
	if not multiplayer.peer_connected.is_connected(_on_peer_connected):
		multiplayer.peer_connected.connect(_on_peer_connected)
		
	if multiplayer.is_server():
		add_player(1)

func _on_peer_connected(id: int) -> void:
	add_player(id)

func add_player(id: int) -> void:
	var scene_path = "res://scripts/player.gd/character_body_2d.tscn" if id == 1 else "res://scripts/player.gd/player_2.tscn"
	var player = load(scene_path).instantiate()
	player.name = str(id)
	player.set_multiplayer_authority(id) 
	
	$Players.add_child(player, true)
