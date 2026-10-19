extends Node2D

@onready var bgs = [$background, $Background2, $Background3]
@onready var timer = $Timer

var current = 0

var Port = 23456
var Ip_adress = '127.0.0.1'

func _on_create_host_btn_pressed() -> void:
	var peer = ENetMultiplayerPeer.new()
	peer.create_server(Port, 2)
	multiplayer.multiplayer_peer = peer
	get_tree().change_scene_to_file("res://coop_level.tscn")
	
func _on_join_btn_pressed() -> void:
	var peer = ENetMultiplayerPeer.new()
	peer.create_client(Ip_adress, Port)
	multiplayer.multiplayer_peer = peer
	get_tree().change_scene_to_file("res://coop_level.tscn")

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
