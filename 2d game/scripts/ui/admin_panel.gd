extends CanvasLayer

const SKELETON = preload("res://scripts/enemy.tscn")
const YELLOW = preload("res://scripts/boss.gd/yellow_enemy.tscn")

func _ready():
	visible = false

func _input(event):
	if event.is_action_pressed("ui_admin"):
		visible = not visible
		
func _spawn(scene):
	var player = get_tree().get_first_node_in_group("player")
	if not player: return
	var enemy = scene.instantiate()
	enemy.global_position = player.global_position + Vector2(200, 0)
	get_tree().current_scene.add_child(enemy)


func _on_button_pressed() -> void:
	_spawn(SKELETON)


func _on_button_2_pressed() -> void:
	_spawn(YELLOW)


func _on_button_3_pressed() -> void:
	pass # Replace with function body.


func _on_button_4_pressed() -> void:
	var player = get_tree().get_first_node_in_group("player")
	if player:
		player.playerHp = player.MAX_HP

func _on_button_5_pressed() -> void:
	for enemy in get_tree().get_nodes_in_group("enemies"):
		enemy.queue_free()
	


func _on_button_6_pressed() -> void:
	for p in get_tree().get_nodes_in_group("player"):
		p.god_mode = not p.god_mode


func _on_button_7_pressed() -> void:
	Engine.time_scale = 0.3


func _on_button_8_pressed() -> void:
	Engine.time_scale = 2.0


func _on_button_9_pressed() -> void:
	Engine.time_scale = 1.0


func _on_button_10_pressed() -> void:
	for p in get_tree().get_nodes_in_group("player"):
		p.playerHp = 0
		p.die()
	
