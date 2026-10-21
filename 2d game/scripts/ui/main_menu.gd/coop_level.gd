extends Node2D

func _ready() -> void:
	if not multiplayer.peer_connected.is_connected(_on_peer_connected):
		multiplayer.peer_connected.connect(_on_peer_connected)
		
	if not multiplayer.peer_disconnected.is_connected(_on_peer_disconnected):
		multiplayer.peer_disconnected.connect(_on_peer_disconnected)
		
	if multiplayer.is_server():
		add_player(1)
		await get_tree().create_timer(1.0).timeout
		spawn_enemies()

func _on_peer_disconnected(id: int) -> void:
	if $Players.has_node(str(id)):
		$Players.get_node(str(id)).queue_free()
		print("Игрок ", id, " отключился, удаляем его персонажа.")

func _on_peer_connected(id: int) -> void:
	await get_tree().create_timer(0.5).timeout
	
	if id != 1 and $Players.has_node(str(id)):
		$Players.get_node(str(id)).queue_free()
		
	add_player(id)

func add_player(id: int) -> void:
	if $Players.has_node(str(id)):
		return

	var scene_path = "res://scripts/player.gd/character_body_2d.tscn" if id == 1 else "res://scripts/player.gd/player_2.tscn"
	
	var player = load(scene_path).instantiate()
	player.name = str(id)
	player.set_multiplayer_authority(id) 
	$Players.add_child(player, true)

func spawn_enemies() -> void:
	if not multiplayer.is_server():
		return
		
	print("--- НАЧАЛО СПАВНА ВРАГОВ ---")
	
	var white_scene = load("res://scripts/enemy.tscn")
	if white_scene == null:
		print("ОШИБКА: Не могу найти белого скелета!")
		return
		
	var white_skeleton = white_scene.instantiate()
	$Enemy2.add_child(white_skeleton) 
	white_skeleton.global_position = Vector2(500, 300) 
	print("Белый скелет заспавнен!")

	var yellow_scene = load("res://scripts/boss.gd/yellow_enemy.tscn")
	if yellow_scene == null:
		print("ОШИБКА: Не могу найти желтого скелета!")
		return
		
	var yellow_skeleton = yellow_scene.instantiate()
	$Enemy2.add_child(yellow_skeleton) 
	yellow_skeleton.global_position = Vector2(700, 300) 
	print("Желтый скелет заспавнен!")
