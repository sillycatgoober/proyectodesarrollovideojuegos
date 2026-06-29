extends CanvasLayer

@export var boton_escena: PackedScene
@onready var burbuja_cliente = $chat
@onready var texto_cliente = $chat/Margin/VBox/RichTextLabel
@onready var nombre = $chat/Margin/VBox/Label
@onready var burbuja_jugador = $inspectorChat
@onready var texto_jugador = $inspectorChat/Margin/RichTextLabel
@onready var contenedor_opciones = $ChoiceContainer
@onready var nombre_label = $Label
@onready var anim_ojos = $AnimOjos
@onready var sprite_personaje: TextureRect = $Ratio/Control/Client
@onready var seleccion = $Seleccion
var personaje_actual:=""

var sprites = {
	"jefa": preload("res://Assets/Imagenes/Sprites/Jefe.png"),
	"cliente1": preload("res://Assets/Imagenes/Sprites/c1.png"),
	"cliente2": preload("res://Assets/Imagenes/Sprites/c2.png"),
	"cliente3": preload("res://Assets/Imagenes/Sprites/c3.png")
}

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	anim_ojos.visible = false
	sprite_personaje.visible = false
	seleccion.visible = false
	UI.leave_menu.visible = false
	UI.pause_menu.visible = false
	UI.blur_pausa.visible = false
	sprite_personaje.material.set_shader_parameter("progress", 0.0)
	DialogManager.dialogo_actualizado.connect(_on_dialogo_actualizado)
	DialogManager.dialogo_terminado.connect(_on_dialogo_terminado)
	DialogManager.personaje_sale.connect(_on_personaje_sale)
	DialogManager.personaje_entra.connect(_on_personaje_entra)
	if GameManager.fase_actual == GameManager.Fase.DIAGNOSTICO:
		anim_ojos.visible = true
		anim_ojos.play("open")
		await anim_ojos.animation_finished
		anim_ojos.visible = false
	
	match GameManager.fase_actual:
		GameManager.Fase.INTRO:
			DialogManager.iniciar_dialogo("intro")
		GameManager.Fase.ENTREVISTA:
			GameManager.actualizar_cliente()
			var pre = "transicion_pre_" + str(GameManager.dream_actual)
			if pre in DialogManager.dialogos:
				GameManager.sub_fase = "pre"
				DialogManager.iniciar_dialogo(pre)
			else:
				DialogManager.iniciar_dialogo("cliente" + str(GameManager.dream_actual))
		GameManager.Fase.DIAGNOSTICO:
			GameManager.actualizar_cliente()
			GameManager.sub_fase = "intro"
			DialogManager.iniciar_dialogo("salida_inmersion")

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		if texto_cliente.escribiendo:
			texto_cliente.completar_texto()
			return
		if texto_jugador.escribiendo:
			texto_jugador.completar_texto()
			return
		if contenedor_opciones.get_child_count() == 0:
			DialogManager.avanzar()

func _on_dialogo_actualizado(quien: String, texto: String, opciones: Array) -> void:
	await cambiar_personaje(quien)
	burbuja_cliente.visible = false
	burbuja_jugador.visible = false
	match quien:
		"Cliente":
			burbuja_cliente.visible = true
			texto_cliente.mostrar_texto(texto)
			nombre.text = GameManager.nombre_cliente_actual
		"Jefe":
			burbuja_cliente.visible = true
			texto_cliente.mostrar_texto(texto)
			nombre.text = "Jefa"
		"Inspector":
			burbuja_jugador.visible = true
			texto_jugador.mostrar_texto(texto)
	
	for hijo in contenedor_opciones.get_children():
		hijo.queue_free()
	
	for i in opciones.size():
		var boton = boton_escena.instantiate()
		boton.text = opciones[i]["texto"]
		var idx = i
		boton.pressed.connect(func(): DialogManager.elegir_opcion(idx))
		contenedor_opciones.add_child(boton)

func _on_dialogo_terminado() -> void:
	match GameManager.fase_actual:
		GameManager.Fase.INTRO:
			GameManager.fase_actual = GameManager.Fase.ENTREVISTA
			GameManager.actualizar_cliente()
			DialogManager.iniciar_dialogo("cliente" + str(GameManager.dream_actual))
		GameManager.Fase.ENTREVISTA:
			if GameManager.sub_fase == "pre":
				GameManager.sub_fase = ""
				GameManager.actualizar_cliente()
				DialogManager.iniciar_dialogo("cliente" + str(GameManager.dream_actual))
			else:
				GameManager.fase_actual = GameManager.Fase.SUENO
				GameManager.guardar()
				anim_ojos.visible = true
				anim_ojos.play("close")
				await anim_ojos.animation_finished
				get_tree().change_scene_to_file("res://Scenes/dream" + str(GameManager.dream_actual) + ".tscn")
		GameManager.Fase.DIAGNOSTICO:
			if GameManager.sub_fase == "intro":
				GameManager.sub_fase = "seleccion"
				mostrar_pantalla_diagnostico()
			elif GameManager.sub_fase == "reaccion":
				GameManager.sub_fase = "post"
				DialogManager.iniciar_dialogo("transicion_post_" + str(GameManager.dream_actual))
			elif GameManager.sub_fase == "post":
				if GameManager.dream_actual >= 3:
					anim_ojos.visible = true
					anim_ojos.play("close")
					await anim_ojos.animation_finished
					get_tree().change_scene_to_file("res://Scenes/fin.tscn")
				else:
					GameManager.dream_actual += 1
					GameManager.guardar()
					anim_ojos.visible = true
					anim_ojos.play("close")
					await anim_ojos.animation_finished
					get_tree().change_scene_to_file("res://Scenes/diax.tscn")

func _on_personaje_sale() -> void:
	personaje_actual = ""
	await desvanecer()
func _on_personaje_entra() -> void:
	personaje_actual = ""

func mostrar_pantalla_diagnostico() -> void:
	seleccion.visible = true

func diagnostico_elegido(tipo: String) -> void:
	GameManager.diagnostico_final = tipo
	GameManager.sub_fase = "reaccion"
	var correcto = GameManager.diagnostico_correcto_actual()
	var es_correcto = tipo == correcto
	GameManager.dreams[str(GameManager.dream_actual)]["diagnostico_correcto"] = es_correcto
	var sufijo = "correcto" if es_correcto else "incorrecto"
	DialogManager.iniciar_dialogo("cliente" + str(GameManager.dream_actual) + "_reaccion_" + sufijo)

#---- CAMBIAR SPRITE ----#
func cambiar_personaje(quien: String) -> void:
	if quien == personaje_actual or quien=="Inspector" or quien=="":
		return
	personaje_actual = quien
	var key = ""
	match quien:
		"Jefe": key = "jefa"
		"Cliente": key = "cliente" + str(GameManager.dream_actual)
		"Inspector":
			await desvanecer()
			return
	if key in sprites:
		await desvanecer()
		sprite_personaje.texture = sprites[key]
		await aparecer()

func aparecer() -> void:
	sprite_personaje.visible = true
	var tween = create_tween()
	tween.tween_method(
		func(v): sprite_personaje.material.set_shader_parameter("progress", v),
		0.0, 1.0, 0.5
	)
	await tween.finished

func desvanecer() -> void:
	if not sprite_personaje.visible:
		return
	var tween = create_tween()
	tween.tween_method(
		func(v): sprite_personaje.material.set_shader_parameter("progress", v),
		1.0, 0.0, 0.5
	)
	await tween.finished
	sprite_personaje.visible = false
#---- FIN CAMBIAR SPRITE ----#

func usa_cursor_libre() -> bool:
	return true
