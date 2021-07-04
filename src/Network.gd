extends Node

var peer = NetworkedMultiplayerENet.new()

const SERVER_IP = "127.0.0.1"
const SERVER_PORT = 13400
const MAX_PLAYERS = 2

# Player info, associate ID to data
var player_info = {}
# Info we send to other players
var my_info = {
	name = "speed",
}

func _ready():
	get_tree().connect("network_peer_connected", self, "_player_connected")
	get_tree().connect("network_peer_disconnected", self, "_player_disconnected")
	get_tree().connect("connected_to_server", self, "_connected_ok")
	get_tree().connect("connection_failed", self, "_connected_fail")
	get_tree().connect("server_disconnected", self, "_server_disconnected")

func init(server):
	if server:
		peer.create_server(SERVER_PORT, MAX_PLAYERS)
	else:
		peer.create_client(SERVER_IP, SERVER_PORT)

	get_tree().network_peer = peer

func _player_connected(id):
	# Called on both clients and server when a peer connects. Send my info to it.
	rpc_id(id, "register_player", my_info)

func _player_disconnected(id):
	player_info.erase(id) # Erase player from info.

func _connected_ok():
	pass # Only called on clients, not server. Will go unused; not useful here.

func _server_disconnected():
	pass # Server kicked us; show error and abort.

func _connected_fail():
	pass # Could not even connect to server; abort.

remote func register_player(info):
	# Get the id of the RPC sender.
	var id = get_tree().get_rpc_sender_id()
	# Store the info
	player_info[id] = info

func smth():
	get_tree().set_refuse_new_network_connections(true)
