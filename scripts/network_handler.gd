extends Node

# Server Signals
signal on_peer_connected(peer_id: int)
signal on_peer_disconnected(peer_id: int)
signal on_server_packet(peer_id: int, data: PackedByteArray)

# Client Signals
signal on_connected_to_server()
signal on_disconnected_from_server()
signal on_client_packet(data: PackedByteArray)

# Server Variables
const IP_ADDRESS: String = "127.0.0.1"
const PORT: int = 49000
const MAX_CLIENTS: int = 32
var available_peer_ids: Array = range(255, 1, -1)
var client_peers: Dictionary[int, ENetPacketPeer]

# Client Variables
var server_peer: ENetPacketPeer

# General Variables
var connection: ENetConnection
var is_server: bool = false

# Runs every frame
func _process(delta: float) -> void:
	# If there are no network connections, return
	if connection == null: return
	
	handle_events()
	
# Handles network packets
func handle_events() -> void:
	var packet_event: Array = connection.service()
	var event_type: ENetConnection.EventType = packet_event[0]
	
	while event_type != ENetConnection.EVENT_NONE:
		var peer: ENetPacketPeer = packet_event[1]
		
		match event_type:
			ENetConnection.EVENT_ERROR:
				push_warning("Packet error")
				return
				
			ENetConnection.EVENT_CONNECT:
				pass
				
			ENetConnection.EVENT_DISCONNECT:
				pass
				
			ENetConnection.EVENT_RECEIVE:
				pass
				

func start_server(ip_address: String = IP_ADDRESS, port: int = PORT) -> void:
	connection = ENetConnection.new()
	var error: Error = connection.create_host_bound(ip_address, port, MAX_CLIENTS)
	if error:
		print("Server starting failed:", error_string(error))
		connection = null
		return
		
	print("Server started.")
	is_server = true

func start_client(ip_address: String = IP_ADDRESS, port: int = PORT) -> void:
	connection = ENetConnection.new()
	var error: Error = connection.create_host(1)
	if error:
		print("Client starting failed:", error_string(error))
		connection = null
		return
	
	# No errors here. Connect client to the server.
	print("Client started.")
	server_peer = connection.connect_to_host(ip_address, port)
