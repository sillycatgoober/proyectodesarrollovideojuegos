extends CanvasLayer

@onready var label_texto = $chat/RichTextLabel
@onready var contenedor_opciones = $HBoxContainer

@export var personaje_id: String = "talia"

func _ready() -> void:
	DialogManager.dialogo_actualizado.connect(_on_dialogo_actualizado)
	DialogManager.dialogo_terminado.connect(_on_dialogo_terminado)
	DialogManager.iniciar_dialogo(personaje_id)

func _on_dialogo_actualizado(texto: String, opciones: Array) -> void:
	label_texto.mostrar_texto(texto, 2.0)
	
	for hijo in contenedor_opciones.get_children():
		hijo.queue_free()
	
	for i in opciones.size():
		var boton = Button.new()
		boton.text = opciones[i]["texto"]
		boton.pressed.connect(func(): DialogManager.elegir_opcion(i))
		contenedor_opciones.add_child(boton)

func _on_dialogo_terminado() -> void:
	get_tree().change_scene_to_file("res://Scenes/dream1.tscn")
