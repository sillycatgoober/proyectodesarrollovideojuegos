extends CanvasLayer

@onready var label_texto = $chat/RichTextLabel
@onready var contenedor_opciones = $HBoxContainer
@onready var nombre_label = $Label
@export var personaje_id: String = "cliente1"

func _ready() -> void:
	DialogManager.dialogo_actualizado.connect(_on_dialogo_actualizado)
	DialogManager.dialogo_terminado.connect(_on_dialogo_terminado)
	match GameManager.fase_actual:
		GameManager.Fase.INTRO:
			DialogManager.iniciar_dialogo("intro")
		GameManager.Fase.ENTREVISTA:
			DialogManager.iniciar_dialogo("cliente" + str(GameManager.dream_actual))
		GameManager.Fase.DIAGNOSTICO:
			DialogManager.iniciar_dialogo("cliente" + str(GameManager.dream_actual) + "_diagnostico")

func _input(event: InputEvent) -> void:
	if event.is_action_just_pressed("interact"):
		if contenedor_opciones.get_child_count() == 0:
			DialogManager.avanzar()

func _on_dialogo_actualizado(quien: String, texto: String, opciones: Array) -> void:
	label_texto.mostrar_texto(texto, 2.0)
		
	if nombre_label:
		match quien:
			"inspector": nombre_label.text = "Inspector"
			"cliente": nombre_label.text = GameManager.nombre_cliente_actual
			_: nombre_label.text = quien
	
	for hijo in contenedor_opciones.get_children():
		hijo.queue_free()
	
	for i in opciones.size():
		var boton = Button.new()
		boton.text = opciones[i]["texto"]
		boton.pressed.connect(func(): DialogManager.elegir_opcion(i))
		contenedor_opciones.add_child(boton)

func _on_dialogo_terminado() -> void:
	match GameManager.fase_actual:
		GameManager.Fase.INTRO:
			GameManager.fase_actual = GameManager.Fase.ENTREVISTA
			DialogManager.iniciar_dialogo("cliente" + str(GameManager.dream_actual))
		GameManager.Fase.ENTREVISTA:
			GameManager.fase_actual = GameManager.Fase.SUENO
			GameManager.guardar()
			get_tree().change_scene_to_file("res://Scenes/dream" + str(GameManager.dream_actual) + ".tscn")
		GameManager.Fase.DIAGNOSTICO:
			GameManager.dream_actual += 1
			GameManager.fase_actual = GameManager.Fase.ENTREVISTA
			GameManager.guardar()
