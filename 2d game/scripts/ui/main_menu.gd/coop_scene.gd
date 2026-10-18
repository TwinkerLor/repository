extends Node2D

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
