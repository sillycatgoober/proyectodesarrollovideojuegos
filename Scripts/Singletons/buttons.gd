extends Node

var hover_sound: AudioStream = preload("res://Assets/Audio/SFX/hover.wav")
var press_sound: AudioStream = preload("res://Assets/Audio/SFX/stamp.wav")

var audio_player: AudioStreamPlayer

func _ready() -> void:
	audio_player = AudioStreamPlayer.new()
	audio_player.bus = "SFX"
	add_child(audio_player)
	get_tree().node_added.connect(_on_node_added)
	# conecta los botones que ya existen
	get_tree().scene_changed.connect(_on_scene_changed)
	_conectar_botones_existentes()

func _on_scene_changed(scene: Node) -> void:
	_conectar_botones_existentes()

func _conectar_botones_existentes() -> void:
	await get_tree().process_frame
	for boton in get_tree().get_nodes_in_group(""):
		pass
	for boton in get_tree().get_nodes_in_group("stamp_bot"):
		if not boton.mouse_entered.is_connected(_on_hover):
			boton.mouse_entered.connect(_on_hover)
		if not boton.pressed.is_connected(_on_press):
			boton.pressed.connect(_on_press)

func _on_node_added(node: Node) -> void:
	if node is BaseButton:
		node.mouse_entered.connect(_on_hover)
		node.pressed.connect(_on_press)

func _on_hover() -> void:
	audio_player.stream = hover_sound
	audio_player.play()

func _on_press() -> void:
	audio_player.stream = press_sound
	audio_player.play()
