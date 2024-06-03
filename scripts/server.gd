extends Node3D

@onready var main_menu = $MainMenu
@onready var address_entry = $MainMenu/VBoxContainer/AddressEntry

const Player = preload("res://scenes/player.tscn")

const PORT = 9999
var enet_peer = ENetMultiplayerPeer.new()

func host_button_pressed():
	main_menu.hide()
	
	enet_peer.create_server(PORT)
	multiplayer.multiplayer_peer = enet_peer
	multiplayer.peer_connected.connect(add_player)
	
	add_player(multiplayer.get_unique_id())


func join_button_pressed():
	main_menu.hide()
	enet_peer.create_client("localhost", PORT)
	multiplayer.multiplayer_peer = enet_peer


func add_player(peer_id):
	var player = Player.instantiate()
	player.name = str(peer_id)
	add_child(player)
	player.global_position = player.global_position + Vector3(0, 0.5, 0)
