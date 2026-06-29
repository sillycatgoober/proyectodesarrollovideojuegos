extends Interactuable

@export var manager: Node
@export_enum("trabajo", "familia") var tipo_archivo: String = "trabajo"
@export var modelo_archivo: PackedScene
@export var label_info: Label
@onready var model = $Model

func _ready() -> void:
	camara = $Camera3D
	if modelo_archivo:
		var instancia = modelo_archivo.instantiate()
		model.add_child(instancia)

func interact():
	var player = get_player()
	if player == null: return
	en_interaccion = !en_interaccion
	if en_interaccion:
		player.puede_moverse = false
		camara.current = true
	else:
		player.puede_moverse = true
		player.set_camara_activa(true)
		label_info.text = ""

func _input(event: InputEvent) -> void:
	if not en_interaccion:
		return
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		if not InventoryManager.has_item("encendedor"):
			UI.set_hints("No creo poder hacer algo con esto ahora")
			return
		quemar_archivo()
		get_viewport().set_input_as_handled()

func quemar_archivo():
	if label_info:
		label_info.text = ""
		
	var player = get_player()
	if player:
		player.puede_moverse = true
		player.set_camara_activa(true)
	
	if manager and manager.has_method("on_archivo_quemado"):
		manager.on_archivo_quemado(tipo_archivo)
	
	queue_free()
